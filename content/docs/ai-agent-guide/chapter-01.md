---
title: "제1장: 에이전트가 '테스트 통과'를 외쳐도 소프트웨어가 망가지는 이유"
date: 2026-08-24
tags: ["AI", "Testing", "TestOracle", "ConfirmationBias"]
---

# 제1장: 에이전트가 "테스트 통과"를 외쳐도 소프트웨어가 망가지는 이유

---

## 1. 이 장의 결론

> **"테스트 통과(Green)는 '소프트웨어가 올바르다'는 뜻이 아니라, 단지 '주어진 테스트 코드가 에러 없이 끝났다'는 뜻일 뿐이다."**  
> 에이전트에게 테스트 작성을 위임할 때 발생하는 가장 치명적인 결함은 **테스트 오라클(Test Oracle)의 오염**과 **자기 확증 편향(Self-Confirmation Bias)**이다. 검증되지 않은 테스트 코드는 거짓된 안정감을 주어 실제 런타임 장애를 유발한다.

---

## 2. 이 문제가 중요한 이유

AI 코딩 에이전트를 도입한 많은 개발자가 다음과 같은 '가짜 성공의 덫'에 빠집니다.
에이전트가 수십 줄의 코드를 작성하고 단위 테스트를 실행한 뒤 `"All 12 tests passed!"`를 출력하면, 개발자는 안도하고 코드를 병합합니다. 그러나 프로덕션에 배포되는 순간, 필수 필드가 누락되었거나 경계 조건에서 예외가 터져 서비스가 중단됩니다.

왜 이런 일이 발생할까요?
1. **단언문 누락 (Missing Assertion)**: 에이전트는 종종 함수를 호출하기만 하고 실제 반환값이나 상태 변화를 검증하지 않는 테스트를 작성합니다.
2. **거짓 오라클 (False Oracle)**: 에이전트가 버그가 있는 구현 코드를 작성한 뒤, 그 버그의 반환값을 '정상 기대값'으로 간주하는 테스트를 작성합니다.
3. **도구 실행 왜곡 (Hallucinated Execution)**: 테스트가 실패했음에도 로그를 왜곡 해석하여 성공으로 보고하거나, 테스트 러너의 실행 실패(Exit code $\neq$ 0)를 통과로 둔갑시킵니다.

---

## 3. 핵심 개념

### 3.1 테스트 오라클 문제 (The Test Oracle Problem)
소프트웨어 테스팅에서 '오라클(Oracle)'이란 **"주어진 입력에 대해 시스템이 산출해야 하는 참된 결과(Ground Truth)를 판별하는 메커니즘"**을 말합니다.
에이전트에게 코드와 테스트 작성을 동시에 맡기면, 에이전트는 자신이 작성한 코드의 출력을 오라클로 삼아버립니다. 이는 학생이 시험 문제를 풀고 스스로 채점 기준표를 만들어 100점을 주는 것과 같습니다.

### 3.2 자기 확증 편향 (Self-Confirmation Bias)
동일한 LLM 컨텍스트는 자신이 세운 잘못된 도메인 가정(예: "모든 사용자는 반드시 이메일을 가진다")을 테스트 코드에도 그대로 복제합니다. 따라서 결함이 존재하더라도 동일한 가정을 공유하는 테스트는 무조건 통과(Green)하게 됩니다.

---

## 4. 잘못된 접근 사례

### [사례 1: 단순 CRUD 사용자 등록 기능] - 잘못된 구현 및 테스트

개발자가 *"사용자 생성 CRUD API를 구현하고 테스트를 작성해줘"*라고 단순 요청했을 때 에이전트가 생성한 전형적인 엉터리 테스트:

```typescript
// ❌ 잘못된 테스트 예시: 단언문 부실 및 거짓 오라클
describe('UserService - Create User', () => {
  it('사용자를 성공적으로 생성해야 한다', async () => {
    const service = new UserService();
    const result = await service.createUser({ name: '홍길동', age: -5 }); // 음수 나이라는 비정상 입력
    
    // 치명적 결함 1: 단순히 정의되었는지만 확인 (단언문 부실)
    expect(result).toBeDefined();
    
    // 치명적 결함 2: 음수 나이가 들어갔는데도 ID가 발급되었다고 성공 판정 (거짓 오라클)
    expect(result.id).toBeTruthy();
  });
});
```

* **문제점**:
  - 나이가 `-5`인 유효하지 않은 데이터가 들어왔음에도 유효성 검증 예외가 발생하지 않고 통과합니다.
  - 실제 DB에 저장되었는지, 이메일 중복 시 어떻게 되는지 검증하지 않습니다.
  - 에이전트는 `"테스트 1개 통과 완료!"`라고 보고합니다.

---

## 5. 개선된 접근 사례

### 참된 오라클과 3계층 단언문이 적용된 테스트

```typescript
// ✅ 개선된 테스트: 명확한 오라클 및 네거티브 검증
describe('UserService - Create User', () => {
  let service: UserService;
  let fakeRepo: InMemoryUserRepository;

  beforeEach(() => {
    fakeRepo = new InMemoryUserRepository();
    service = new UserService(fakeRepo);
  });

  it('유효한 사용자 정보가 주어지면 DB에 저장하고 생성된 엔티티를 반환한다', async () => {
    const input = { name: '홍길동', age: 25, email: 'hong@example.com' };
    const result = await service.createUser(input);

    // 1. 반환값의 정확한 필드 검증
    expect(result).toMatchObject({
      name: '홍길동',
      age: 25,
      email: 'hong@example.com',
    });
    expect(result.id).toBeDefined();

    // 2. 영속성 계층(DB) 상태 변화 검증
    const savedUser = await fakeRepo.findById(result.id);
    expect(savedUser).toEqual(result);
  });

  it('나이가 음수인 경우 InvalidAgeError 예외를 발생시켜야 한다 (Negative Verification)', async () => {
    const invalidInput = { name: '홍길동', age: -5, email: 'hong@example.com' };

    await expect(service.createUser(invalidInput))
      .rejects
      .toThrow(InvalidAgeError);
  });
});
```

---

## 6. 실제 작업 프롬프트

에이전트에게 엉터리 테스트를 만들지 못하도록 강제하는 프롬프트:

```markdown
당신은 엄격한 TDD 엔지니어입니다.
`UserService.createUser` 기능을 구현하고 검증 테스트를 작성하십시오.

[작업 원칙]
1. 테스트 코드 작성 시 `toBeDefined()`, `toBeTruthy()`와 같은 모호한 단언문 사용을 금지합니다.
2. 정상 케이스: 반환 데이터의 모든 필드 일치 및 DB 영속화 상태를 반드시 단언(Assert)하십시오.
3. 예외 케이스: 나이 < 0, 이메일 형식 오류, 필수값 누락에 대해 각각 구체적인 도메인 예외가 발생하는지 검증하십시오.
4. 구현 전, 테스트가 실제로 실패(Red)하는 실행 로그를 먼저 제출하십시오.
```

---

## 7. 에이전트가 제출해야 할 증거 (Evidence)

1. **실패 증명 로그 (Failing First Log)**: 구현 코드가 없을 때 테스트가 실패했음을 보여주는 터미널 원본 출력.
2. **성공 증명 로그 (Pass Log)**: 구현 완료 후 `exit code 0`과 함께 모든 단언문이 통과한 터미널 출력.
3. **검증된 엣지 케이스 매트릭스**: 입력값과 기대 결과의 1:1 매핑 표.

---

## 8. 사람이 확인할 사항

- [ ] 에이전트가 테스트의 기대값(`expected`)을 구현 코드의 버그에 맞춰 수정하지 않았는가?
- [ ] DB 저장이나 외부 호출을 모킹(Mock)하면서 실제 비즈니스 유효성 검사까지 통째로 건너뛰지 않았는가?
- [ ] 터미널 실행 로그에 `0 failed, 0 errors`가 명확히 찍혀 있는가?

---

## 9. 팀 적용 방법

- **CI 파이프라인 단언문 검사기 도입**: PR에 추가된 테스트 코드 중 `expect().toBeDefined()`만 존재하는 빈 껍데기 테스트를 감지하여 빌드를 실패시키는 린트 룰(`eslint-plugin-jest`) 설정.
- **테스트 리뷰 기준 문서화**: 코드 리뷰 시 "테스트 통과 여부"가 아닌 "테스트 단언문의 엄격성"을 우선 검토 항목으로 지정.

---

## 10. 체크리스트

- [ ] 정상 시나리오뿐 아니라 비정상(예외) 시나리오 테스트가 최소 2개 이상 존재하는가?
- [ ] 단언문이 객체의 세부 속성과 DB 상태를 엄밀하게 비교하고 있는가?
- [ ] 에이전트가 테스트 러너를 실제로 실행하고 종료 코드를 확인했는가?

---

## 11. 연습 문제 및 실습

**과제**: 에이전트에게 "간단한 이메일 유효성 검증 함수" 작성을 지시하고, 에이전트가 만든 테스트에 `test@domain..com` (점 2개 연속) 같은 엣지 케이스가 누락되었는지 확인한 뒤, 템플릿 7을 활용하여 테스트를 보강하게 하시오.

---

## 12. 참고 자료

- Ammann, P., & Offutt, J. (2016). *Introduction to Software Testing*. Cambridge University Press. (테스트 오라클 이론)
- Barr, E. T., et al. (2015). *The Oracle Problem in Software Testing: A Survey*. IEEE TSE.
