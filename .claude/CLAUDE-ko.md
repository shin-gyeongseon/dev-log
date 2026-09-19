# CLAUDE.md

이 파일은 이 저장소에서 코드 작업을 할 때 Claude Code(claude.ai/code)에게 제공하는 가이드입니다.

## 이 저장소는 무엇인가

[Quartz](https://quartz.jzhao.xyz/)(v5) 기반으로 만든 개인 디지털 가든 / 블로그입니다. `content/`의 마크다운 노트는 Obsidian이나 VS Code로 작성되며, 정적 사이트로 빌드되어 `main`에 푸시할 때마다 GitHub Actions를 통해 GitHub Pages에 배포됩니다. 저자용 워크플로 전체(한국어)는 README.md를 참고하세요.

- 라이브 사이트: https://shin-gyeongseon.github.io/dev-log/
- `quartz/`는 vendored된 Quartz 엔진(빌드 파이프라인, 컴포넌트, 플러그인 로더)입니다. 프레임워크 코드로 취급하고, 대부분의 작업에서는 수정할 필요가 없습니다.
- `content/`는 실제 콘텐츠(노트/포스트)입니다. 일상적인 작업 대부분이 여기서 이루어집니다.
- `public/`은 생성된 빌드 결과물입니다 — 절대 직접 수정하지 마세요.

## 명령어

```bash
# 실시간 미리보기가 가능한 로컬 개발 서버 (http://localhost:8080)
npx quartz build --serve

# 타입 체크 + Prettier 검사 (커밋 전에 실행)
npm run check

# Prettier로 자동 포맷팅
npm run format

# 테스트 실행 (tsx --test; quartz/ 전체에서 *.test.ts / *.test.js 를 찾음)
npm test

# 단일 테스트 파일 실행
npx tsx --test quartz/util/path.test.ts

# quartz.config.yaml에 선언된 Quartz 커뮤니티 플러그인 재설치/동기화
npm run install-plugins

# 프로덕션 빌드 전체 실행 (public/에 결과물 작성)
npx quartz build
```

Node >= 20, npm >= 10 (package.json의 `.node-version`, `engines` 참고).

## 콘텐츠 작성

- 노트는 `content/<Category>/*.md` 아래에 위치합니다 (예: `content/AI`, `content/Architecture`, `content/DevOps`). 각 카테고리 폴더에는 `index.md`가 있습니다.
- Obsidian 스타일 문법을 지원합니다: 위키링크(`[[Note]]`, `[[Note|alias]]`), 콜아웃(`> [!NOTE]`), 태그(`#tag`), KaTeX 수식, 체크리스트/표.
- `quartz.config.yaml`의 `ignorePatterns`에 나열된 경로(현재 `private`, `templates`, `.obsidian`)는 빌드에서 제외됩니다.
- `main`에 푸시하면 `.github/workflows/deploy.yml`이 트리거되어 `npx quartz build`를 실행하고 `public/`을 GitHub Pages에 배포합니다 — 수동 배포 단계가 필요 없습니다.

## 아키텍처: 플러그인 기반 빌드

Quartz의 빌드(`quartz/build.ts`, `quartz/cli/handlers.js`를 통해 조율됨)는 세 개의 프로세서 단계로 이루어진 파이프라인이며, 각 단계는 `quartz.config.yaml`에 선언된 플러그인들로 구성됩니다.

1. **Parse** (`quartz/processors/parse.ts`) — 마크다운을 AST로 변환하며, `transformers` 플러그인을 사용합니다 (frontmatter/note-properties, obsidian/github-flavored markdown, 문법 강조, latex, crawl-links, description, created-modified-date 등)
2. **Filter** (`quartz/processors/filter.ts`) — `filters` 플러그인(예: `remove-draft`, `unlisted-pages`, `explicit-publish`)을 통해 페이지를 제외합니다
3. **Emit** (`quartz/processors/emit.ts`) — `emitters`/`pageTypes` 플러그인을 통해 최종 결과물을 렌더링합니다 (콘텐츠 페이지, 폴더 페이지, 태그 페이지, 캔버스 페이지, `content-index`를 통한 sitemap/RSS, og-image, favicon, alias-redirects)

플러그인 대부분은 로컬 코드가 아니라 외부 `@quartz-community/*` npm 패키지입니다 — 어떤 플러그인이 활성화되어 있는지, 각 단계 내 실행 순서(`order`)와 레이아웃(왼쪽/오른쪽 사이드바, beforeBody, footer, toolbar group 같은 UI 슬롯을 위한 `position`/`priority`)을 결정하는 소스 오브 트루스는 `quartz.config.yaml`입니다. 사이트 동작을 바꾸려면 `quartz/` 내부를 건드리기보다 `quartz.config.yaml`에서 플러그인을 켜고 끄거나 재설정하는 쪽을 우선하세요.

로컬(vendored되지 않은) 코드는 `quartz/components/`(Preact/TSX UI: `Header`, `Body`, `PageList` 등, `quartz/components/registry.ts`에 등록됨)와 `quartz/util/`(경로 처리, 익스플로러용 파일 트라이, 슬러그 충돌 해결, 테마, i18n)에 있습니다. 이들은 각각 함께 위치한 `*.test.ts` 파일을 가지고 있으며 `npm test`로 실행할 수 있습니다.

테마/타이포그래피/색상(폰트, 라이트/다크 팔레트)은 SCSS가 아니라 `quartz.config.yaml`의 `theme` 아래에서 설정됩니다 — `quartz/styles/*.scss`는 구조적인 스타일만 담당합니다.
