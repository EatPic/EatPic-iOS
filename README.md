# 🚀 프로젝트 이름

![배너 이미지 또는 로고](링크)

> 간단한 한 줄 소개 – 프로젝트의 핵심 가치 또는 기능

[![Swift](https://img.shields.io/badge/Swift-6.0.3-orange.svg)]()
[![Xcode](https://img.shields.io/badge/Xcode-16.0-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---

<br>

## 👥 멤버
| 리버(이재원) | 증윤(송승윤) | 데이지(원주연) | 비엔(이은정) |
|:------:|:------:|:------:|:------:|
| ![사진1](https://github.com/user-attachments/assets/d5ede2c4-01db-4426-b63e-6484ce18041f) | ![사진2](https://github.com/user-attachments/assets/14739279-1ae4-40ce-a566-585b37ed23eb) | ![사진3](https://github.com/user-attachments/assets/35e0094d-7289-4da2-971b-dc0b56361e7f) | ![사진4](https://github.com/user-attachments/assets/545523bb-ac74-451c-a1ea-c0d81e4ca021) |
| PL | FE | FE | FE |
| [GitHub](https://github.com/jwon0523) | [GitHub](https://github.com/SongCodeMaster) | [GitHub](https://github.com/jutamin) | [GitHub](https://github.com/codenameVien) |

<br>


## 📱 소개

> 프로젝트의 주요 목적과 사용자가 얻게 될 경험을 설명해주세요.

<br>

## 📆 프로젝트 기간
- 전체 기간: `2025.06.23 - 2025.08.22`
- 개발 기간: `2025.07.12 - 2025.08.22`

<br>

## 🔎 기술 스택
### Envrionment
<div align="left">
<img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" />
<img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" />
<img src="https://img.shields.io/badge/SPM-FA7343?style=for-the-badge&logo=swift&logoColor=white" />
</div>

### Development
<div align="left">
<img src="https://img.shields.io/badge/SwiftUI-42A5F5?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Alamofire-FF5722?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Moya-8A4182?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Kingfisher-0F92F3?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Combine-FF2D55?style=for-the-badge&logo=apple&logoColor=white" />
</div>

### Communication
<div align="left">
<img src="https://img.shields.io/badge/Notion-white.svg?style=for-the-badge&logo=Notion&logoColor=000000" />
<img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=Discord&logoColor=white" />
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" />
</div>

<br>

## 📱 화면 구성
<table>
  <tr>
    <td>
      사진 넣어주세요
    </td>
    <td>
      사진 넣어주세요
    </td>
   
  </tr>
</table>

## 🗂️ 폴더 컨벤션

해당 폴더 구조는 초기 기준을 제시하며, 이후 파일이 추가되더라도 README에 모두 반영하지 않습니다.<br>  
단, 새로운 폴더가 생길 경우에는 구조에 포함하여 관리합니다.<br>

```bash
EatPic-iOS/
├── .github/                          
├── Sources/
│   ├── App/
│   │   ├── AppDelegate.swift         # (필요시 추가) 앱 생명주기
│   │   └── EatPicIOSApp.swift        # @main 앱 진입점
│   │
│   ├── Core/
│   │   ├── Network/
│   │   │   ├── NetworkService.swift         # MoyaProvider 관리
│   │   │   ├── TargetType/                  # Moya Target 정의
│   │   │   │   └── AuthAPI.swift
│   │   │   └── DTO
│   │   │       ├── Request/                     # API 요청 모델(Codable)
│   │   │       │   └── LoginRequset.swift
│   │   │       └── Response/                    # API 응답 모델(Codable)
│   │   │           └── LoginResponse.swift
│   │   │
│   │   └── Environment/                   # 앱 환경과 과련된 전체 설정(의존성, 빌드 환경, 플래그 등)
│   │       └── DIConttainer.swift         # 전역 의존성 주입을 위한 환경 구성
│   │
│   ├── Components/
│   │   └── Common/
│   │       ├── PrimaryButton.swift
│   │       └── RoundedTextField.swift
│   │
│   ├── Screens/    # 화면에 맞추어 추가하면 됨 
│   │   ├── Login/
│   │   │   ├── LoginView.swift
│   │   │   └── LoginViewModel.swift
│   │   │   
│   │   └── Home/
│   │       ├── HomeView.swift
│   │       └── HomeViewModel.swift
│   │
│   ├── Models/   # 모델 저장 위치
│   │   ├── LoginModel.swift
│   │   └──  HomeModel.swift
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   ├── Colors.xcassets/
│   │   ├── Secrets.xcconfig
│   │   └── Fonts/
│   │       └── # 확정되면 작성
│   │
│   └── Utilities/
│       ├── Extensions/
│       │   ├── Color+Extensions.swift
│       │   ├── Font+Extensions.swift
│       │   └── View+Extensions.swift
│       ├── Config/
│       │   └── Config.swift
│       ├── Constants/
│       │   └── UIConstants.swift
│       └── Preview/
│           └── DevicePreviewHelper.swift
│
├── Tests/ 
│   ├── EatPicIOSTests.swift
│   └── CoreTests/          # 추후 테스트코드 작성시 추가
│
├── mise.toml               # mise 환경설정 파일
├── Project.swift           # Tuist 프로젝트 정의 파일
├── Tuist/                  # Tuist 관련 패키지 및 설정
│   ├── Package.resolved
│   └── Package.swift
├── Tuist.swift             # Tuist 진입점 스크립트
└── .gitignore              # Git 무시 파일
```

## 브랜치 전략
- `Github-flow` 사용
- 모든 브랜치는 main 브랜치에서 분기

### 🔖 브랜치 컨벤션
* `main` - 메인 브랜치
* `feat/xx` - 기능 단위로 독립적인 개발 환경을 위해 작성
* `refactor/xx` - 개발된 기능을 리팩토링 하기 위해 작성
* `chore/xx` - 빌드 작업, 패키지 매니저 설정 등
* `design/xx` - 디자인 변경
* `fix/xx` - 버그 수정
* `test/xx` - 테스트 코드 작업 및 수행

## 📑 커밋 컨벤션

### 💬 깃모지 가이드

| 아이콘 | 코드 | 설명 | 원문 |
| :---: | :---: | :---: | :---: |
| 🐛 | bug | 버그 수정 | Fix a bug |
| ✨ | sparkles | 새 기능 | Introduce new features |
| 💄 | lipstick | UI/스타일 파일 추가/수정 | Add or update the UI and style files |
| ♻️ | recycle | 코드 리팩토링 | Refactor code |
| ➕ | heavy_plus_sign | 의존성 추가 | Add a dependency |
| 🔀 | twisted_rightwards_arrows | 브랜치 합병 | Merge branches |
| 💡 | bulb | 주석 추가/수정 | Add or update comments in source code |
| 🔥 | fire | 코드/파일 삭제 | Remove code or files |
| 🚑 | ambulance | 긴급 수정 | Critical hotfix |
| 🎉 | tada | 프로젝트 시작 | Begin a project |
| 🔒 | lock | 보안 이슈 수정 | Fix security issues |
| 🔖 | bookmark | 릴리즈/버전 태그 | Release / Version tags |
| 📝 | memo | 문서 추가/수정 | Add or update documentation |
| 🔧| wrench | 구성 파일 추가/삭제 | Add or update configuration files.|
| ⚡️ | zap | 성능 개선 | Improve performance |
| 🎨 | art | 코드 구조 개선 | Improve structure / format of the code |
| 📦 | package | 컴파일된 파일 추가/수정 | Add or update compiled files |
| 👽 | alien | 외부 API 변경 반영 | Update code due to external API changes |
| 🚚 | truck | 리소스 이동, 이름 변경 | Move or rename resources |
| 🙈 | see_no_evil | .gitignore 추가/수정 | Add or update a .gitignore file |

### 🏷️ 커밋 태그 가이드

 | 태그        | 설명                                                   |
|-------------|--------------------------------------------------------|
| feat      | 새로운 기능 추가                                       |
| fix       | 버그 수정                                              |
| refactor  | 코드 리팩토링 (기능 변경 없이 구조 개선)              |
| style     | 코드 포맷팅, 세미콜론 누락, 들여쓰기 수정 등          |
| docs      | README, 문서 수정                                     |
| test      | 테스트 코드 추가 및 수정                              |
| chore     | 패키지 매니저 설정, 빌드 설정 등 기타 작업           |
| design    | UI, CSS, 레이아웃 등 디자인 관련 수정                |
| hotfix    | 운영 중 긴급 수정이 필요한 버그 대응                 |
| ci/cd     | 배포 관련 설정, 워크플로우 구성 등                    |

### ✅ 커밋 예시 모음
> 🎉 chore: 프로젝트 초기 세팅 <br>
> ✨ feat: 프로필 화면 UI 구현 <br>
> 🐛 fix: iOS 17에서 버튼 클릭 오류 수정 <br>
> 💄 design: 로그인 화면 레이아웃 조정 <br>
> 📝 docs: README에 프로젝트 소개 추가 <br>

<br>

## 📁 PR 컨벤션
> PR 시, 템플릿이 등장합니다. 해당 템플릿에서 작성해야할 부분은 아래와 같습니다. <br>
  1. `PR 유형 작성`, 어떤 변경 사항이 있었는지 [] 괄호 사이에 x를 입력하여 체크할 수 있도록 한다.  
  2. `작업 내용 작성`, 작업 내용에 대해 자세하게 작성을 한다.  
  3. `추후 진행할 작업`, PR 이후 작업할 내용에 대해 작성한다  
  4. `리뷰 포인트`, 본인 PR에서 꼭 확인해야 할 부분을 작성한다.  
  6. `PR 태그 종류`, PR 제목의 태그는 아래 형식을 따른다.  

#### 🌟 태그 종류 (커밋 컨벤션과 동일)
| 태그        | 설명                                                   |
|-------------|--------------------------------------------------------|
| [Feat]      | 새로운 기능 추가                                       |
| [Fix]       | 버그 수정                                              |
| [Refactor]  | 코드 리팩토링 (기능 변경 없이 구조 개선)              |
| [Style]     | 코드 포맷팅, 들여쓰기 수정 등                         |
| [Docs]      | 문서 관련 수정                                         |
| [Test]      | 테스트 코드 추가 또는 수정                            |
| [Chore]     | 빌드/설정 관련 작업                                    |
| [Design]    | UI 디자인 수정                                         |
| [Hotfix]    | 운영 중 긴급 수정                                      |
| [CI/CD]     | 배포 및 워크플로우 관련 작업                          |

### ✅ PR 예시 모음
> 🎉 [Chore] 프로젝트 초기 세팅 <br>
> ✨ [Feat] 프로필 화면 UI 구현 <br>
> 🐛 [Fix] iOS 17에서 버튼 클릭 오류 수정 <br>
> 💄 [Design] 로그인 화면 레이아웃 조정 <br>
> 📝 [Docs] README에 프로젝트 소개 추가 <br>
