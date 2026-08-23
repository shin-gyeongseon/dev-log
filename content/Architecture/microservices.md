---
title: 대규모 분산 시스템 설계 및 마이크로서비스 핵심 가이드
date: 2026-08-23
tags:
  - system-design
  - microservices
  - backend
  - distributed-systems
---

# 대규모 분산 시스템 설계 및 마이크로서비스 핵심 가이드

트래픽 증가와 복잡도 확장에 유연하게 대처하기 위한 분산 시스템 설계 원칙과 마이크로서비스 아키텍처 패턴을 정리합니다.

---

## 1. CAP 정리 (CAP Theorem)

분산 데이터 스토어는 다음 세 가지 속성 중 최대 2가지만 동시에 보장할 수 있습니다.

$$
\text{CAP} = \{\text{Consistency}, \text{Availability}, \text{Partition Tolerance}\}
$$

| 분류 | 특징 | 주요 기술 예시 |
| :--- | :--- | :--- |
| **CP 시스템** | 일관성과 네트워크 분할 내성을 선택 (가용성 희생) | Redis, HBase, ZooKeeper |
| **AP 시스템** | 가용성과 네트워크 분할 내성을 선택 (최종 일관성) | Cassandra, DynamoDB, CouchDB |
| **CA 시스템** | 분산 네트워크 환경에서는 네트워크 분할이 필연적이므로 실질적으로 분산 DB에서 부적합 | 단일 RDBMS |

---

## 2. 분산 시스템 핵심 컴포넌트

```
[클라이언트 앱]
       │
       ▼
[로드 밸런서 (Nginx / ALB)]
       │
       ▼
[API 게이트웨이 (인증/인가, Rate Limiting)]
       ├──▶ [인증 서비스] ──▶ [User DB]
       ├──▶ [주문 서비스] ──▶ [Order DB] ──▶ [Kafka Event Bus]
       └──▶ [결제 서비스] ──▶ [Payment DB]         │
                                                   ▼
                                         [알림 서비스 (Consumer)]
```

### 1) API Gateway
- 클라이언트 요청의 단일 진입점 역할을 수행하며, 라우팅, SSL 인증서 처리, 요청 제한(Rate Limiting), 인증 토큰 검증을 중앙 처리합니다.

### 2) 캐싱 전략 (Cache-Aside Pattern)
- 데이터베이스 부하를 줄이기 위해 Redis와 같은 인메모리 캐시를 활용합니다.
```python
async def get_user_data(user_id: str):
    # 1. 캐시 조회
    cached_data = await redis_client.get(f"user:{user_id}")
    if cached_data:
        return json.loads(cached_data)

    # 2. DB 조회 (Cache Miss)
    db_data = await db.fetch_user(user_id)
    
    # 3. 캐시 저장 (TTL: 3600초)
    await redis_client.setex(f"user:{user_id}", 3600, json.dumps(db_data))
    return db_data
```

### 3) 이벤트 기반 비동기 통신 (Event-Driven)
- 서비스 간 결합도(Coupling)를 낮추기 위해 Apache Kafka, RabbitMQ 등의 메시지 브로커를 활용합니다.

---

## 3. 요약 및 권장 사항

> [!TIP] 아키텍처 진화 원칙
> 초기 시스템은 모놀리식(Monolithic) 또는 모듈러 모놀리스로 단순하게 시작하고, 트래픽과 팀 규모가 커지는 병목 시점에 점진적으로 마이크로서비스로 분리하는 것이 바람직합니다.

---

## 4. 연관 문서

- 코드 레벨의 아키텍처: [[Architecture/clean-architecture|소프트웨어 클린 아키텍처]]
- 메인 인덱스: [[index|📚 지식 정리 노트 메인]]
- 배포 파이프라인: [[DevOps/git-github-actions|GitHub Actions 배포 파이프라인]]
