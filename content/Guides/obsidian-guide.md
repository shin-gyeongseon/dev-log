---
title: 옵시디언 & 마크다운 핵심 문법 및 활용 가이드
date: 2026-08-23
tags:
  - obsidian
  - markdown
  - guide
  - quartz
---

# 옵시디언 & 마크다운 핵심 문법 및 활용 가이드

옵시디언(Obsidian)과 본 블로그(Quartz)에서 공통으로 지원하는 강력한 마크다운 문법들을 정리합니다.

---

## 1. 콜아웃 (Callouts)

옵시디언 스타일의 다채로운 콜아웃 블록을 사용할 수 있습니다.

> [!NOTE] 기본 안내 (Note)
> 가장 기본적인 메모 및 참고사항을 작성할 때 사용합니다.

> [!TIP] 유용한 팁 (Tip)
> 유용한 팁이나 권장 사항을 강조할 때 사용합니다.

> [!WARNING] 주의 사항 (Warning)
> 주의해야 할 설정이나 에러 가능성이 있는 항목을 나타냅니다.

> [!CAUTION] 경고 (Caution)
> 데이터 유실이나 보안 문제 등 위험 요소에 사용합니다.

---

## 2. 양방향 위키링크 (WikiLinks)

옵시디언의 핵심 기능인 `[[문서명|표시텍스트]]` 형태의 내부 링크가 블로그에서도 자연스럽게 상호 연결됩니다.

- 홈으로 이동: [[index|📚 지식 정리 노트 메인]]
- 연관 문서 보기: [[Guides/zettelkasten|제텔카스텐 지식 관리 방법론]]

---

## 3. 코드 하이라이팅 (Syntax Highlighting)

다양한 프로그래밍 언어의 구문 강조가 깔끔하게 렌더링됩니다.

```typescript
// TypeScript 인터페이스 정의 예시
interface NoteItem {
  id: string;
  title: string;
  tags: string[];
  createdDate: Date;
  isPublished: boolean;
}

function filterPublishedNotes(notes: NoteItem[]): NoteItem[] {
  return notes.filter((note) => note.isPublished);
}
```

```python
# Python 데코레이터 예시
import time

def timing_decorator(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"[{func.__name__}] 실행 시간: {time.time() - start:.4f}초")
        return result
    return wrapper
```

---

## 4. 수식 렌더링 (KaTeX / LaTeX)

인라인 수식과 블록 수식을 모두 지원합니다.

- **인라인 수식**: 오일러 공식 $e^{i\pi} + 1 = 0$
- **블록 수식**:
$$
f(x) = \frac{1}{\sigma \sqrt{2\pi}} e^{-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2}
$$

---

## 5. 체크리스트 및 표 (Tables)

### 진행 상태 체크리스트
- [x] Quartz v4/v5 정적 사이트 엔진 세팅
- [x] 옵시디언 마크다운 호환성 구성
- [x] GitHub Actions 자동 배포 파이프라인 연동
- [ ] 첫 번째 나만의 기술 아티클 작성

### 마크다운 테이블
| 기능                | 옵시디언 로컬 지원 | 웹 블로그 지원 |
| :---------------- | :--------: | :------: |
| 위키링크 (`[[링크]]`)   |     ✅      |    ✅     |
| 콜아웃 (`> [!NOTE]`) |     ✅      |    ✅     |
| 그래프 뷰             |     ✅      |    ✅     |
| 수식 ($\LaTeX$)     |     ✅      |    ✅     |
