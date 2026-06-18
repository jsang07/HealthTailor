# health_tailor

### Auth(social Login) / onboarding
![auth](https://postfiles.pstatic.net/MjAyMzEyMDhfMTQw/MDAxNzAyMDA5ODE0NDk3.sJBzenaQCvs81vt_0l7krdvmbUBQZBugrlcqm_Mb7s8g.QWU8-Dv7XPxsVjjFQYWLnP59iaQHB7JS4wCrdO5oKI0g.PNG.umm0714/%EC%A0%9C%EB%AA%A9%EC%9D%84-%EC%9E%85%EB%A0%A5%ED%95%B4%EC%A3%BC%EC%84%B8%EC%9A%94_-001_(6).png?type=w966)

### Home
![home](https://postfiles.pstatic.net/MjAyMzEyMDhfMTgg/MDAxNzAyMDA5ODE0NTA4.2sPPNpPE6ZbEvRPQ9llqjSY7C3M2U3fJsPvvf-Ux0Lgg.Mqr6rf2SJzrxFb7LjAT4JTplWnXwY5ra-GaM1lfHOxUg.PNG.umm0714/001.png?type=w966)

### buy / social
![buy](https://postfiles.pstatic.net/MjAyMzEyMDhfMjE0/MDAxNzAyMDEwMDA3MzE1.u6dxGt3M8HjXJd58ZVyAG3RixwSUoGXNoVZnztGx-Pcg.KxVzY8k0rIDC7_HofTcueec15mzguZvTofq8BjEMfa8g.PNG.umm0714/%EC%A0%9C%EB%AA%A9%EC%9D%84-%EC%9E%85%EB%A0%A5%ED%95%B4%EC%A3%BC%EC%84%B8%EC%9A%94_-001_(6).png?type=w966)


#### **📌 1. 프로젝트 개요 & 시스템 아키텍처**

- **도입 배경:** 개인 맞춤형 헬스케어 시장이 성장함에 따라, 유저의 실시간 신체 스펙(BMI)과 영양 상태를 직관적으로 관리하고 공공 데이터 포털의 영양제 공공 API를 매끄럽게 앱 내에 정제하여 시각화하기 위해 개발되었습니다.
- **시스템 구조:**
    - **Frontend:** Flutter (Android / iOS MVP 비즈니스 크로스 플랫폼 앱)
    - **Backend:** Firebase (Auth, Firestore, Storage)

#### 🛠️ 2. 핵심 구현 기능

- **온보딩 기반 데이터 연산 시스템:** 유저가 가입 시 입력한 성별, 연령, 신장, 체중 데이터를 기반으로 런타임에서 BMI를 실시간 계산하고 개인 맞춤형 대시보드 UI 스케일링 반영.
- **소셜 인증 및 세션 커스텀 매핑:** 구글 및 카카오 SDK를 Firebase Auth 인증 스트림과 연동하여 유저 고유 세션의 지속성 확보.
- **동적 QR 코드 생성 및 소셜 런타임 CRUD:** 유저 고유 데이터 식별을 위한 실시간 QR 이미지 뷰를 구현하고, 피드 내 좋아요 및 댓글 등의 소셜 데이터 인터랙션 비동기 처리.

#### 🔥 3. 기술적 도전 및 트러블슈팅

☑️ 온보딩 입력 데이터와 UI 렌더링 시퀀스 간의 Null-Safety 예외 처리

- **문제 상황:** 최초 가입한 유저가 신체 정보를 입력하는 온보딩 프로세스 도중, 특정 필수 값이 Firestore에 완전히 동기화되기 전에 대시보드 메인 화면이 먼저 빌드되면서 BMI 연산 함수가 `Null check operator used on a null value` 런타임 에러를 뿜으며 앱이 튕기는 결함 발생.
- **원인 분석:** Firebase 비동기 데이터 페칭 타이밍과 Flutter 위젯 트리 렌더링 생명주기 간의 레이스 컨디션으로 인해, 미처 데이터가 수신되지 않은 시점에 강제로 신체 스펙 필드에 접근하여 발생한 버그로 진단.
- **해결 방법:** 데이터 모델 설계 단에서 원천적으로 강력한 기본값 프로토콜을 정의하고, UI 렌더링 단을 `FutureBuilder` 및 `StreamBuilder` 구조로 감싸 데이터 로딩 상태를 명시적으로 분기 처리. 데이터 동기화가 완료되기 전까지는 Lottie 애니메이션 스켈레톤 UI를 노출하도록 시퀀스를 보완.

☑️ 소셜 로그인 OAuth 토큰 핸드쉐이크 및 세션 유지 안정화

- **문제 상황:** 외부 소셜 로그인(네이버, 카카오 등) 서드파티 인증 완료 후, 해당 액세스 토큰을 Firebase Auth Credential로 변환하는 과정에서 가끔 인증 세션이 풀리거나 토큰 갱신이 비정상적으로 차단되어 재로그인을 요구하는 사용성 저하 문제 확인.
- **해결 방법:** 앱 글로벌 루트 레이어에 Firebase `authStateChanges()` 리스너를 전역 스트림으로 바인딩하여 세션 상태 변화를 실시간으로 구독하도록 아키텍처 개편. 토큰 유효성 검증 실패 시 백그라운드에서 조용히 토큰 재발급  핸들러가 트리거되도록 예외 처리 로직을 주입하여 이탈 없는 매끄러운 유저 가입 및 진입 흐름 확보.

#### 📈 4. 프로젝트 성과 및 회고

- **정량적 성과:** 아이디어의 기술적 구현 가능성을 MVP 빌드를 통해 입증하여 창업 경진대회 최종 본선 진출 및 우수상 수상 성과 달성. 효율적인 컴포넌트 설계를 위해 반복 사용되는 텍스트 입력 폼과 밸리데이션 로직을 공통 컴포넌트 10여 종으로 모듈화하여 개발 생산성 향상
- **회고:** 플러터 생태계에 입문하던 시기에 비동기 데이터 흐름과 상태 관리의 중요성을 뼈저리게 깨닫게 해준 값진 프로젝트입니다. 기술적 미숙함을 공식 문서 분석과 예외 처리 방어 코딩을 통해 정면으로 돌파하며, 결과적으로 수상이라는 비즈니스 성과까지 리드해 낸 단단한 기반이 되었습니다.
