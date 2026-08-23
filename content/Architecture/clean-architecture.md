---
title: 소프트웨어 클린 아키텍처와 계층형 설계 패턴
date: 2026-08-23
tags:
  - architecture
  - clean-code
  - backend
  - design-pattern
---

# 소프트웨어 클린 아키텍처와 계층형 설계 패턴

소프트웨어 시스템의 지속 가능성과 테스트 용이성을 극대화하기 위한 클린 아키텍처(Clean Architecture) 원칙을 정리합니다.

---

## 1. 클린 아키텍처의 핵심 계층 구조

클린 아키텍처의 대원칙은 **의존성 역전 원칙(Dependency Inversion Principle)**에 따라 모든 의존성이 고수준의 비즈니스 정책(도메인) 방향으로만 향해야 한다는 것입니다.

```
+-------------------------------------------------------+
|  Frameworks & Drivers (Web, DB, External APIs, UI)     |
|    +------------------------------------------------+ |
|    |  Interface Adapters (Controllers, Gateways)     | |
|    |    +-----------------------------------------+ | |
|    |    |  Use Cases (Application Business Rules) | | |
|    |    |    +----------------------------------+ | | |
|    |    |    |  Entities (Enterprise Rules)     | | | |
|    |    |    +----------------------------------+ | | |
|    |    +-----------------------------------------+ | |
|    +------------------------------------------------+ |
+-------------------------------------------------------+
```

---

## 2. 계층별 책임 정의

### 1) Entity (엔티티)
- 핵심 비즈니스 모델과 비즈니스 불변식(Invariants)을 캡슐화합니다.
- 외부 프레임워크나 라이브러리에 일절 의존하지 않는 순수한 도메인 객체입니다.

### 2) Use Case (유스케이스)
- 시스템이 제공하는 비즈니스 흐름(Flow)을 오케스트레이션합니다.
- 예: `CreateUserUseCase`, `ProcessPaymentUseCase`

### 3) Interface Adapters (인터페이스 어댑터)
- 외부 세계의 데이터 형식(HTTP Request/Response, SQL Result)과 유스케이스가 다루는 데이터 형식을 상호 변환합니다.

### 4) Frameworks & Drivers (인프라스트럭처)
- 데이터베이스(PostgreSQL, Redis), 웹 프레임워크(FastAPI, Express, Spring Boot), 외부 메시지 큐 등 구체적인 기술 스택이 위치합니다.

---

## 3. 코드 구현 패턴 (TypeScript 예시)

### Repository 인터페이스 (Domain Layer)
```typescript
// domain/repositories/user-repository.interface.ts
export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}

export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<void>;
}
```

### Use Case 구현 (Application Layer)
```typescript
// usecases/get-user-profile.usecase.ts
import { IUserRepository, User } from '../domain/repositories/user-repository.interface';

export class GetUserProfileUseCase {
  constructor(private readonly userRepository: IUserRepository) {}

  async execute(userId: string): Promise<User> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new Error(`User with ID ${userId} not found`);
    }
    return user;
  }
}
```

---

## 4. 연관 지식 링크

- 분산 환경에서의 아키텍처 확장: [[Architecture/microservices|대규모 분산 시스템 설계 가이드]]
- 마크다운 작성 팁: [[Guides/obsidian-guide|옵시디언 마크다운 가이드]]
