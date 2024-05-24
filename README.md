# Table of Contents
1. [Description](#description)
2. [Timeline](#timeline)
3. [Demo](#demo)
4. [Features](#features)
5. [Requirements](#requirements)
6. [Stacks](#stacks)
7. [ProjectStructure](#projectStructure)
8. [Developer](#developer)

# TURTLE VOCA

<img src="https://img.shields.io/badge/Apple-%23000000.svg?style=for-the-badge&logo=apple&logoColor=white" height="20"> <img src="https://img.shields.io/badge/iOS-16.0%2B-green"> <img src="https://img.shields.io/badge/Library-Combine-308C4A "> <img src="https://img.shields.io/badge/Library-Firebase-308C4A "> <img src="https://img.shields.io/badge/Library-KakaoOpenSDK-308C4A "> <img src="https://img.shields.io/badge/Library-ProgressHUD-308C4A "> <img src="https://img.shields.io/badge/Library-SnapKit-308C4A ">

영단어든, 코드용어든 관계 없다!!
내가 기억하고 싶은 단어만, 스스로 만드는 나만의 단어장!
TURTLE VOCA

## Description

거북이의 단어장(TURTLE VOCA)은 사용자가 원하는 단어장과 외우고 싶은 단어를 직접 입력하고 수정하여 사용할 수 있는 편리한 단어 학습 어플리케이션입니다.
이 어플리케이션은 다음과 같은 주요 기능을 제공합니다:

단어장 생성 및 수정: 사용자가 자신만의 단어장을 만들고 자유롭게 수정할 수 있습니다. 개인 학습에 최적화된 단어장 관리 기능을 제공합니다.

단어 생성 및 수정: 사용자가 학습을 원하는 단어를 생성하고, 단어에 대한 다양한 정보를 자유롭게 입력할 수 있습니다.
캘린더 기능: 학습한 단어를 캘린더에 저장하여 관리할 수 있습니다. 매일 학습한 단어를 기록하고 확인할 수 있습니다.
게임을 통한 리마인더: 간단한 퀴즈 형식의 게임을 통해 외운 단어들을 복습할 수 있는 기능을 제공합니다. 게임을 통해 재미있게 단어를 기억하고 학습 효율을 높일 수 있습니다.
카카오 및 애플 연동: 카카오톡과 애플 계정을 통한 간편 로그인 기능을 제공합니다. 사용자는 자신이 선호하는 플랫폼을 통해 쉽게 어플에 접근할 수 있습니다.
iCloud 연동: iCloud와 연동되어, 사용자가 저장한 단어장을 안전하게 백업하고 여러 기기에서 동기화하여 사용할 수 있습니다.
DeepL API 통합: DeepL API를 통해 번역 서비스를 제공합니다. 단어를 번역해주는 기술을 단어 저장에 활용할 수 있습니다.
카카오 클라우드 Translation : 카카오의 음성 합성 기술을 이용해 단어를 소리 내어 읽어주는 기능을 제공합니다. 청각적 학습을 통해 단어의 발음을 익히고 기억할 수 있습니다.

거북이의 단어장은 여러분의 언어 학습을 더 즐겁고 체계적으로 만들어줄 것입니다. 조금 느리더라도 꾸준히 학습할 수 있는 나만의 단어장을 만들어 보세요!

## Timeline

<details>
   <summary>24.05.13</summary>
    <pre>● Project 아이디어 회의
    ○ 컨셉, 역할 분담, 와이어프레임
● UIDesign
    ○ Calender, BookCase, GameMain 페이지 구현
    </pre>
</details>

<details>
   <summary>24.05.14</summary>
        <pre>● UIDesign
   ○ 단어 추가 페이지 구현
● Filter 기능 구현 
● Quiz 기능 구현
   ○ Dummy Data를 통한 기능 테스트
        </pre>
</details>

<details>
   <summary>24.05.15</summary>
    <pre>● UIDesign
   ○ MyPage, 단어장 추가, FlashCard 페이지 구현
● FlashCard 기능 구현
   ○ Dummy Data를 통한 기능 테스트
    </pre>
</details>

<details>
   <summary>24.05.16</summary>
   <pre>● UIDesign
   ○ 단어입력 페이지 구현
● MyPage, 단어장 이미지 추가 기능 구현
● 단어 저장시 Coredata와 연결

   </pre>
</details>

<details>
   <summary>24.05.17</summary>
   <pre>● UIDesign
   ○ 단어상세 페이지 구현
● 단어 정렬 Userdefault에 값 저장 
● 단어 저장시, 저장한 날짜 활성화 효과 추가
● 단어 삭제기능 구현 (Swipe Action)
   ○ Coredata와 연동
● 서치바 기능 구현
● Coredate에 저장된 단어장 UI 출력
● Hangman 게임 구현
   </pre>
</details>

<details>
   <summary>24.05.18</summary>
   <pre>● UIDesign
   ○ 게임기록 페이지 구현
● Calender와 Coredata 연결
   ○ 날짜별 단어 확인
● UIMenu를 사용한 단어장 삭제, 수정 기능 구현
● 응원 문구 랜덤 출력
● Apple 로그인 기능 구현
   </pre>
</details>    

<details>
   <summary>24.05.19</summary>
   <pre>● 단어 필터링을 통한 정렬 기능 구현
● 단어장 추가에 대한 예외 처리
   ○ 버튼 비활성화 및 Animation을 통해 유져에게 인지
● 단어장의 이미지가 없는 경우에 대한 예외 처리
● 단어장을 보여주는 CollectionViewCell Animation 구현
   </pre>
</details> 

<details>
   <summary>24.05.20</summary>
   <pre>● UIDesign
   ○ 단어상세 페이지 구현
● 단어 상세 페이지 기능 구현   
● 선택한 날짜에 대한 단어 필터링 기능 구현
   ○ 필터링 된 단어의 외우기 기능 및 전체 삭제 기능 추가   
● TTS를 사용한 단어 스피치 기능 구현
● 단어장과 단어 간 Coredata RelationShip 연결
● 게임 설정 기능 구현
   </pre>
</details> 

<details>
   <summary>24.05.21</summary>
   <pre>● KakaoTalk 소셜 로그인 기능 구현
● 로고 및 런치스크린 구현
● Hangman에서 Turtle game으로 UIDesign 변경
● NetworkManager 구현
   ○ DeepL API를 사용한 단어 자동 번역
● 게임 기록(틀린단어) 저장 구현
● Turtle game 예외 처리
   </pre>
</details> 

<details>
   <summary>24.05.22</summary>
   <pre>● 로그인, 로그아웃 기능 구현
● Tabbar 디자인 수정
● 단어 상세페이지 편집 기능 구현
● quiz, 게임 설정 예외 처리
● iCloud 저장 기능 구현
   </pre>
</details> 

<details>
   <summary>24.05.23</summary>
   <pre>● iCloud로부터 데이터 불러오기 기능 구현
● Keyboard Toolbar 추가
● 키보드 내려가지 않는 문제 수정
● 기능 및 UI 최종 점검
● 예외 처리
● ReadMe 작성
   </pre>
</details> 

## Demo
<p float="left">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/2bbbe11f-c57f-400b-be38-75c3b3639a64" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/804e714d-7f27-4684-89cd-1ce20104da27" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/bed9bdc5-1647-4e86-8bcb-ced3aa731c2f" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/dd4fb27a-a1c9-4cb5-9828-0266998764b4" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/8f8f4484-1f23-4f1f-acc0-6b912cb03338" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/01760a0e-76da-4b78-a3c1-4d8b2fa2941d" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/6bcd7d3d-dc11-4fae-b9ff-d61c93866d02" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/8b163606-912b-4cc1-88e6-ef5b2d7ce49a" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/e69c6ebe-3b99-4323-a922-c373fdf0d30b" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/a79b70e9-8d98-415c-8336-7717d02383e9" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/eaebd6ea-5c81-4095-a51f-72cc2860ecd9" width="200" height="430">
<img src="https://github.com/SijongKim93/Vocabulary/assets/97341336/d66f2ebd-81ea-4895-a10c-150e9ec00919" width="200" height="430">
<img src="" width="200" height="430">
<img src="" width="200" height="430">
<img src="" width="200" height="430">
<img src="" width="200" height="430">
<img src="" width="200" height="430">
<img src="" width="200" height="430">
</p>

## Features

### 단어
- 단어 추가 기능
- 단어 수정 기능
- 단어 삭제 기능
- 저장된 단어 검색 기능
- 사전 검색 기능
- 단어 추가시 단어 자동 번역 기능
- 단어 발음 들려주는 기능
- 단어 암기 여부 표시 기능
- 단어 추가시 필수 입력 부분이 빠질 경우 Alert 표시

### 단어장
- 단어장 추가 기능
- 단어장 수정 기능
- 단어장 삭제 기능
- 단어장 이미지 저장 기능
- 단어장 추가 시 빈 공간에 대한 Animation 구현
- 단어장 스크롤시 Animation 구현

### 단어외우기
- FlashCard 기능
- 단어 Quiz 기능
- Turtle Game
- 오답 기록 기능
- 게임 설정 기능

### 캘린더
- 날짜별 추가된 단어 표시
- 다섯가지의 필터링 기능
- 단어 외우기 체크 기능
- 단어 전체 삭제 기능
- Calendar Up&Down을 통한 더 많은 단어 표시

### 마이페이지
- 저장된 단어, 외운 단어, 게임 횟수 확인
- iCloud 단어장 저장 및 복구 기능
- 로그인 시, 로그아웃으로 바뀌는 기능 구현

### 소셜로그인
- Apple Login 구현
- KakaoTalk Login 구현

## Requirements
- App requires **iOS 16.0 or above**

## Stacks
- **Environment**

    <img src="https://img.shields.io/badge/-Xcode-147EFB?style=flat&logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/-git-F05032?style=flat&logo=git&logoColor=white"/>

- **Language**

    <img src="https://img.shields.io/badge/-swift-F05138?style=flat&logo=swift&logoColor=white"/> 

- **API**

    <img src="https://img.shields.io/badge/-DeepL-0F2B46?style=flat&logo=DeepL&logoColor=white"/> <img src="https://img.shields.io/badge/-Firebase-FFCA28?style=flat&logo=Firebase&logoColor=white"/> <img src="https://img.shields.io/badge/-iCloud-3693F3?style=flat&logo=icloud&logoColor=white"/> <img src="https://img.shields.io/badge/-KakaoTalk-FFCD00?style=flat&logo=KakaoTalk&logoColor=white"/>

- **Communication**

    <img src="https://img.shields.io/badge/-Slack-4A154B?style=flat&logo=Slack&logoColor=white"/> <img src="https://img.shields.io/badge/-Notion-000000?style=flat&logo=Notion&logoColor=white"/> <img src="https://img.shields.io/badge/-Figma-F24E1E?style=flat&logo=Figma&logoColor=white"/> <img src="https://img.shields.io/badge/-GitHub-181717?style=flat&logo=Github&logoColor=white"/>

## Project Structure

파일이 많아서 디렉토리 구조로 대체합니다.

```markdown
Vocabulary
├── Config  
│
├── Service
│
├── Extension
│   ├── General
│   └── VocaQuiz
│
├── Factory
│   └── Model
│
├── View
│   ├── EditBookCase
│   ├── BookCase
│   ├── AddBookCase
│   ├── AddVoca
│   ├── VocaQuiz
│   ├── Calender
│   └── MyPage
│
├── Controller
│   ├── BookCase
│   ├── Voca
│   ├── VocaQuiz
│   ├── Calender
│   └── MyPage
│
└── Assets
```

## Developer
*  **김시종** ([SijongKim93](https://github.com/SijongKim93))
   - Calendar 기능 구현
   - 단어 필터링 기능 구현
   - 마이페이지 기능 구현
   - TTS(Text To Speech) 기능 구현
   - Kakao Talk 소셜 로그인 구현
   - UserDefault를 사용한 유져 데이터 저장 구현
   - 단어 외우기 기능 구현
   - 예외 상황 처리

*  **금세미** ([pond1225](https://github.com/pond1225))
   - 단어 추가 기능 구현
   - 단어 수정 기능 구현
   - 단어 삭제 기능 구현
   - 단어 상세페이지 기능 구현
   - SearchBar 기능 구현
   - 예외 상황 처리

*  **김한빛** ([gksqlc7386](https://github.com/gksqlc7386))
   - UI 디자인
   - 단어장 추가 기능 구현
   - 단어장 수정 기능 구현
   - 단어장 삭제 기능 구현
   - Alert 디자인
   - 응원 문구 기능 구현
   - 로고, 런치스크린 구현
   - 키보드 숨김 및 키보드의 UI가림 방지 구현
   - 예외 상황 처리

*  **송동익** ([Haroldfomk](https://github.com/Haroldfromk))
   - 게임(Quiz, Turtle game) 구현
   - FlashCard 기능 구현
   - Api 호출을 통한 단어 뜻 표시 구현
   - Apple 소셜 로그인 기능 구현
   - iCloud 연동 기능 구현
   - Firebase를 통한 유져 데이터 등록 (암호화처리)
   - Keyboard ToolBar 구현
   - 예외 상황 처리
   - Git 문제 해결
    
