# 📚 Dev Log

Obsidian(옵시디언) 및 VS Code에서 작성한 마크다운 노트를 GitHub Pages를 통해 깔끔하고 읽기 편한 기술 블로그 형태로 자동 배포하는 Digital Garden입니다.

---

## 🌐 블로그 주소
- **GitHub Pages URL**: [https://shin-gyeongseon.github.io/dev-log/](https://shin-gyeongseon.github.io/dev-log/)

---

## ✨ 주요 기능 및 특징

1. **Obsidian 완벽 호환**
   - 위키링크(`[[문서명]]`, `[[문서명|별칭]]`) 및 상호 연결
   - 옵시디언 콜아웃 (`> [!NOTE]`, `> [!TIP]`, `> [!WARNING]` 등)
   - 태그(`#tag`), 체크리스트, 테이블
   - 수식 KaTeX 지원 ($E=mc^2$)
   - 인터랙티브 그래프 뷰(Graph View) 및 백링크(Backlinks)

2. **자동 배포 CI/CD (GitHub Actions)**
   - `main` 브랜치에 `git push` 시 자동으로 GitHub Pages에 빌드 및 배포

3. **심플하고 빠른 UI/UX**
   - Noto Sans KR / 모노스페이스 폰트 적용
   - 다크 모드 / 라이트 모드 전환 지원
   - 전역 키보드 검색 (`Ctrl + K` / `Cmd + K`)

---

## ✍️ 사용 방법 (로컬 작성 및 배포)

### 1. Obsidian(옵시디언)으로 작성할 때
1. 옵시디언 실행 후 **Open folder as vault (보관함으로 폴더 열기)**를 클릭합니다.
2. 이 저장소 폴더(`c:\workspace\dev-log`) 또는 `content/` 폴더를 선택합니다.
3. `content/` 폴더 내에 마크다운(`.md`) 파일을 작성하거나 수정합니다.

### 2. VS Code로 작성할 때
1. VS Code에서 `content/` 폴더 내의 `.md` 파일을 열어 편집합니다.

### 3. 로컬 미리보기 (선택 사항)
```bash
# 로컬 개발 서버 실행 (http://localhost:8080)
npx quartz build --serve
```

### 4. GitHub에 푸시하여 자동 배포하기
작성이 완료되면 터미널에서 다음 명령어로 푸시합니다:

```bash
git add .
git commit -m "docs: 새 지식노트 작성"
git push origin main
```

푸시 후 1~2분 내에 GitHub Actions가 실행되어 [블로그](https://shin-gyeongseon.github.io/dev-log/)에 자동 반영됩니다.

---

## ⚙️ GitHub 저장소 필수 초기 설정 (최초 1회)

GitHub Pages가 GitHub Actions를 통해 배포되도록 설정되어 있는지 확인해 주세요:
1. GitHub 저장소(`shin-gyeongseon/dev-log`) 방문
2. **Settings** -> **Pages** 메뉴 이동
3. **Build and deployment** 항목의 **Source**를 **`GitHub Actions`**로 선택
