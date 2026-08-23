---
title: 📚 지식 정리 노트 (Dev Log)
date: 2026-08-23
tags:
  - index
  - intro
  - knowledge
---

# 📚 신경선의 지식 정리 노트 (Dev Log)

> [!TIP] 환영합니다!
> 이 공간은 로컬의 **Obsidian(옵시디언)** 및 **VS Code**에서 작성된 마크다운 기반의 지식들을 GitHub Pages를 통해 웹 블로그 형태로 발행하는 디지털 가든(Digital Garden)입니다.

---

## 🚀 빠른 시작 및 주요 기능

- **마크다운 & 옵시디언 100% 호환**: `[[위키링크]]`, 콜아웃(`> [!NOTE]`), 수식(\(\LaTeX\)), 코드 하이라이팅, 태그 지원
- **자동 배포 파이프라인**: `main` 브랜치에 `git push` 시 GitHub Actions를 통해 수 초 내로 자동 배포
- **인터랙티브 탐색**: 전역 검색(`Ctrl + K` / `Cmd + K`), 인터랙티브 그래프 뷰, 백링크 및 목차 자동 생성

---

## 📑 카테고리별 주요 지식 노트

### 💻 개발 & 아키텍처
- [[posts/02-software-clean-architecture|소프트웨어 클린 아키텍처와 계층형 설계 패턴]]
- [[posts/05-system-design-microservices|대규모 분산 시스템 설계 및 마이크로서비스 핵심 가이드]]

### 🛠️ 도구 & 자동화
- [[posts/01-obsidian-markdown-guide|옵시디언 & 마크다운 핵심 문법 및 활용 가이드]]
- [[posts/03-git-github-pages-workflow|Git Push 기반 GitHub Actions 자동 배포 파이프라인]]

### 🧠 지식 관리 & 생산성
- [[posts/04-effective-knowledge-management|옵시디언 기반 제텔카스텐(Zettelkasten) 지식 관리 방법론]]

---

## 🔍 로컬에서 글 작성하는 방법

1. **Obsidian 사용 시**: 이 프로젝트 폴더를 Obsidian에서 **Open folder as vault**로 열어 `content/` 내에 자유롭게 마크다운 문서를 작성합니다.
2. **VS Code 사용 시**: 마크다운 파일을 작성하거나 수정합니다.
3. **배포**: 터미널에서 변경사항을 커밋하고 푸시합니다.
   ```bash
   git add .
   git commit -m "feat: 새 지식노트 추가"
   git push origin main
   ```
