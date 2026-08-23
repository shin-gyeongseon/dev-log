---
title: 📚 지식 정리 노트 (Dev Log)
date: 2026-08-23
tags:
  - index
  - intro
  - knowledge
  - devops
  - ai
  - architecture
---

# 📚 신경선의 지식 정리 노트 (Dev Log)

> [!TIP] 환영합니다!
> 이 공간은 **DevOps**, **AI**, **Software Architecture**를 중심으로 학습한 기술과 통찰을 체계적으로 기록하고 연결하는 디지털 가든(Digital Garden)입니다.
> Obsidian 및 VS Code에서 마크다운으로 작성되며, GitHub Actions를 통해 자동 발행됩니다.

---

## 🧭 핵심 학습 트랙 (Core Tracks)

관심 있는 카테고리를 선택해 학습 노트와 로드맵을 확인하세요:

| 트랙 | 주요 학습 주제 | 바로가기 |
| :--- | :--- | :---: |
| 🛠️ **DevOps & Cloud** | CI/CD 파이프라인, Docker, Kubernetes, IaC, 관측 가능성 | [[DevOps/index\|탐색하기 →]] |
| 🤖 **AI & Intelligent Systems** | LLM, AI Agent 아키텍처, RAG, 프롬프트 엔지니어링 | [[AI/index\|탐색하기 →]] |
| 🏛️ **Architecture & System Design** | 클린/헥사고날 아키텍처, DDD, MSA, 분산 시스템 설계 | [[Architecture/index\|탐색하기 →]] |
| 📚 **Guides & Knowledge Base** | Obsidian 활용법, 마크다운 문법, 제텔카스텐 지식 관리 | [[Guides/index\|탐색하기 →]] |

---

## 🌟 주요 추천 지식 노트 (Featured Notes)

### 🛠️ DevOps & 배포
- [[DevOps/git-github-actions|Git Push 기반 GitHub Actions 자동 배포 파이프라인]]

### 🏛️ 아키텍처 & 분산 시스템
- [[Architecture/clean-architecture|소프트웨어 클린 아키텍처와 계층형 설계 패턴]]
- [[Architecture/microservices|대규모 분산 시스템 설계 및 마이크로서비스 핵심 가이드]]

### 📚 생산성 & 지식 관리
- [[Guides/obsidian-guide|옵시디언 & 마크다운 핵심 문법 및 활용 가이드]]
- [[Guides/zettelkasten|옵시디언 기반 제텔카스텐(Zettelkasten) 지식 관리 방법론]]

---

## 🔍 지식 작성 & 배포 흐름 (Workflow)

```mermaid
graph LR
    A["📝 로컬 작성 (Obsidian / VS Code)"] --> B["🌿 dev 브랜치 커밋 & 푸시"]
    B --> C["🔀 main 브랜치 PR / 병합"]
    C --> D["🚀 GitHub Actions 자동 배포"]
    D --> E["🌐 GitHub Pages 라이브 반영"]
```

1. **로컬 작성**: Obsidian에서 이 폴더를 Vault로 열거나 VS Code를 통해 마크다운 문서를 작성합니다.
2. **개발 브랜치 커밋**: `dev` 브랜치에서 변경사항을 기록합니다.
3. **배포**: `main` 브랜치에 병합(Merge) 시 GitHub Actions를 통해 수 초 내로 웹 사이트에 자동 반영됩니다.
   ```bash
   # dev 브랜치 작업 후 main으로 반영
   git checkout main
   git merge dev
   git push origin main
   ```
