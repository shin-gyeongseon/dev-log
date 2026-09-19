#!/usr/bin/env bash
# PostToolUse(Write|Edit) hook: keeps .claude/CLAUDE-ko.md in sync with the
# root CLAUDE.md. Reads the hook JSON payload from stdin, and if the edited
# file is the root CLAUDE.md, regenerates its Korean translation via a
# headless `claude -p` call. The English CLAUDE.md is never modified.
set -euo pipefail

input="$(cat)"
file_path="$(node -e '
  let data = "";
  process.stdin.on("data", c => data += c);
  process.stdin.on("end", () => {
    try {
      const j = JSON.parse(data);
      process.stdout.write(j.tool_input?.file_path || j.tool_response?.filePath || "");
    } catch {}
  });
' <<< "$input")"

[ -n "$file_path" ] || exit 0
[ "$(basename "$file_path")" = "CLAUDE.md" ] || exit 0
[ -f "$file_path" ] || exit 0

project_root="$(dirname "$file_path")"
target_path="$project_root/.claude/CLAUDE-ko.md"

# --safe-mode disables hooks for this nested call (while keeping normal auth),
# so it cannot re-trigger itself. It only ever reads $file_path and writes
# $target_path, never touching the English source file.
claude --safe-mode --permission-mode acceptEdits --allowedTools "Edit,Write,Read" -p \
  "$file_path 파일(영어 원문)을 읽고 한국어로 번역해서 그 결과를 $target_path 파일에 작성해줘. 제목과 설명 등 모든 문장은 자연스러운 한국어로 번역하고, 코드 블록/셸 명령어/파일 경로/패키지명 등 기술 식별자는 원문 그대로 유지해. 마크다운 구조는 그대로 유지해. $target_path 파일이 이미 있으면 전체를 덮어쓰고, 없으면 새로 만들어. $file_path 원본 파일은 절대 수정하지 마." \
  >/dev/null 2>&1 || true
