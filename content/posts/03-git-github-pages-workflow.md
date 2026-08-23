---
title: Git Push 기반 GitHub Actions 자동 배포 파이프라인
date: 2026-08-23
tags:
  - git
  - cicd
  - github-actions
  - automation
---

# Git Push 기반 GitHub Actions 자동 배포 파이프라인

로컬에서 마크다운 노트를 작성하고 `git push` 한 번으로 GitHub Pages에 정적 블로그가 자동으로 빌드 및 배포되는 CI/CD 워크플로우를 정리합니다.

---

## 1. 전체 배포 라이프사이클

```
[로컬 마크다운 작성 (Obsidian / VS Code)]
                 │
                 ▼
         [git commit & push]
                 │
                 ▼
      [GitHub Repository (main)]
                 │
                 ▼
  [GitHub Actions Runner 트리거]
    ├── 1. 코드 체크아웃 (Checkout)
    ├── 2. Node.js 환경 준비 (Node 22)
    ├── 3. 의존성 설치 (npm ci)
    ├── 4. Quartz 정적 빌드 (npx quartz build -> public/)
    ├── 5. Pages Artifact 업로드
    └── 6. GitHub Pages 배포 완료!
                 │
                 ▼
  [https://shin-gyeongseon.github.io/dev-log/]
```

---

## 2. 핵심 GitHub Actions 워크플로우 분석

`.github/workflows/deploy.yml` 파일에서 자동 배포를 관장합니다.

> [!TIP] 필수 권한 설정
> GitHub Pages 배포를 위해서는 워크플로우 상단에 아래 권한이 선언되어 있어야 합니다.
> ```yaml
> permissions:
>   contents: read
>   pages: write
>   id-token: write
> ```

### 주요 단계 요약
1. **Concurrency 제어**: 동시 푸시 발생 시 배포 충돌을 방지하기 위해 `group: "pages"` 그룹을 지정합니다.
2. **Build 최적화**: `npx quartz build` 명령어가 `content/` 폴더 내의 마크다운 파일들을 정적 HTML/CSS/JS로 컴파일하여 `public/` 디렉토리에 생성합니다.
3. **Artifact 업로드 & 배포**: `actions/upload-pages-artifact` 및 `actions/deploy-pages`를 통해 GitHub Pages 인프라에 즉시 게시됩니다.

---

## 3. 일상 작업 흐름 (Daily Workflow)

로컬에서 새 노트를 작성하고 배포하는 일상 루틴:

```bash
# 1. 새 글 작성 또는 기존 노트 수정 후 상태 확인
git status

# 2. 변경사항 스테이징 & 커밋
git add .
git commit -m "docs: 분산 시스템 설계 노트 추가"

# 3. 메인 브랜치로 푸시 (자동 배포 시작)
git push origin main
```

푸시 후 GitHub 저장소의 **Actions** 탭에서 실시간 빌드 로그를 확인할 수 있습니다.

---

## 4. 연관 문서

- 전체 인덱스: [[index|📚 지식 정리 노트 메인]]
- 지식 관리 방법론: [[posts/04-effective-knowledge-management|옵시디언 제텔카스텐 방법론]]
