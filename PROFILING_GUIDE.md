# Swift Profile Recorder 사용 가이드

TURTLEVOCA 앱에 Swift Profile Recorder가 통합되었습니다. 이를 사용하면 앱의 성능을 분석하고 병목 지점을 찾을 수 있습니다.

## 📦 설치 방법

### 1. Xcode에서 패키지 추가

1. Xcode에서 프로젝트를 엽니다
2. **File → Add Package Dependencies...** 선택
3. 다음 URL을 입력: `https://github.com/apple/swift-profile-recorder.git`
4. **Dependency Rule**: "Up to Next Minor Version" 선택, `0.3.0` 입력
5. **Add to Target**: `TURTLEVOCA` 선택
6. **Add Package** 클릭

### 2. 패키지 추가 후

패키지가 추가되면 `AppDelegate.swift`의 import 문이 자동으로 작동합니다:

```swift
#if DEBUG
import ProfileRecorder
#endif
```

## 🚀 사용 방법

### 프로파일링 활성화

프로파일링은 **디버그 모드**에서만 작동하며, 환경 변수로 제어됩니다.

#### Xcode에서 활성화

1. **Product → Scheme → Edit Scheme...** (또는 `Cmd+<`)
2. **Run** 탭 선택
3. **Arguments** 탭 선택
4. **Environment Variables** 섹션에서 `+` 버튼 클릭
5. 다음 환경 변수 추가:
   - Name: `ENABLE_PROFILING`
   - Value: `1`
6. **Close** 클릭

#### 설정 확인

앱을 실행하면 콘솔에 다음 메시지가 표시됩니다:

```
✅ Profile Recorder started successfully
📊 Samples will be collected at 10ms interval
```

### 프로파일 데이터 수집

1. 앱을 실행하고 분석하고 싶은 기능을 사용합니다
2. 앱을 종료하면 자동으로 프로파일이 저장됩니다
3. 콘솔에서 프로파일 파일 경로를 확인:

```
✅ Profile saved to: /Users/.../Documents/turtlevoca-profile-1234567890.perf
📁 You can view this file with:
   - speedscope.app (drag and drop)
   - Firefox Profiler (profiler.firefox.com)
```

### 프로파일 파일 가져오기

#### iOS 시뮬레이터에서

```bash
# 시뮬레이터의 Documents 디렉토리 찾기
xcrun simctl get_app_container booted com.yourcompany.TURTLEVOCA data

# 프로파일 파일 복사
cp ~/Library/Developer/CoreSimulator/Devices/[DEVICE_ID]/data/Containers/Data/Application/[APP_ID]/Documents/turtlevoca-profile-*.perf ~/Desktop/
```

#### 실제 기기에서

1. Xcode에서 **Window → Devices and Simulators** 열기
2. 기기 선택
3. **Installed Apps** 섹션에서 TURTLEVOCA 선택
4. 톱니바퀴 아이콘 → **Download Container...** 선택
5. 저장된 `.xcappdata` 파일을 우클릭 → **Show Package Contents**
6. `AppData/Documents/` 폴더에서 `.perf` 파일 찾기

## 📊 프로파일 분석

### Speedscope 사용 (추천)

1. https://www.speedscope.app 접속
2. `.perf` 파일을 브라우저에 드래그 앤 드롭
3. FlameGraph로 성능 병목 지점 확인

### Firefox Profiler 사용

1. https://profiler.firefox.com 접속
2. `.perf` 파일을 브라우저에 드래그 앤 드롭
3. 타임라인 뷰로 성능 분석

### 명령줄에서 분석

```bash
# 심볼 디맹글링
swift demangle --compact < turtlevoca-profile-1234567890.perf > demangled.perf

# FlameGraph 생성 (FlameGraph 도구 필요)
./stackcollapse-perf.pl < demangled.perf | ./flamegraph.pl > flamegraph.svg
open flamegraph.svg
```

## ⚙️ 설정 커스터마이징

`AppDelegate.swift`의 `setupProfileRecorder()` 메서드에서 설정을 변경할 수 있습니다:

```swift
let configuration = ProfileRecorder.Configuration(
    numberOfSamples: 1000,              // 샘플 수 (더 많으면 더 정확)
    sampleInterval: .milliseconds(10),  // 샘플링 간격 (짧으면 더 상세)
    includeSystemCalls: true            // 시스템 콜 포함 여부
)
```

### 권장 설정

- **일반적인 성능 분석**: `numberOfSamples: 1000`, `sampleInterval: .milliseconds(10)`
- **상세한 분석**: `numberOfSamples: 5000`, `sampleInterval: .milliseconds(5)`
- **빠른 스냅샷**: `numberOfSamples: 100`, `sampleInterval: .milliseconds(50)`

## 🎯 활용 예시

### 1. 앱 시작 시간 분석

```swift
// 프로파일링 활성화 후
// 앱 실행 → 메인 화면 로드 → 앱 종료
// → 프로파일 확인하여 초기화 병목 찾기
```

### 2. 특정 기능 성능 분석

```swift
// 예: 단어 검색 기능
// 앱 실행 → 단어장 열기 → 단어 검색 수행 → 앱 종료
// → 프로파일에서 검색 관련 함수 분석
```

### 3. UI 렉 찾기

```swift
// 앱 실행 → 스크롤, 애니메이션 등 UI 조작
// → 프로파일에서 메인 스레드 병목 확인
```

## 🔍 문제 해결

### "Profile Recorder started successfully" 메시지가 보이지 않음

- Scheme의 환경 변수 설정 확인
- 디버그 빌드인지 확인 (Release 빌드는 프로파일링 비활성화)
- 콘솔 출력이 필터링되지 않았는지 확인

### 프로파일 파일을 찾을 수 없음

- 앱을 정상적으로 종료했는지 확인 (강제 종료 시 저장 안됨)
- Documents 디렉토리 경로를 콘솔에서 확인
- 시뮬레이터/기기의 저장 공간 확인

### 빌드 에러 발생

- Swift Profile Recorder 패키지가 제대로 추가되었는지 확인
- Xcode 캐시 클리어: **Product → Clean Build Folder** (`Cmd+Shift+K`)
- 패키지 캐시 리셋: **File → Packages → Reset Package Caches**

## 📚 참고 자료

- [Swift Profile Recorder GitHub](https://github.com/apple/swift-profile-recorder.git)
- [Speedscope Documentation](https://github.com/jlfwong/speedscope)
- [Firefox Profiler Guide](https://profiler.firefox.com/docs/)

## ⚠️ 주의사항

1. **프로덕션 빌드에서는 비활성화됨**: `#if DEBUG` 조건으로 보호됨
2. **성능 영향**: 프로파일링 중에는 약간의 성능 저하 발생 가능
3. **메모리 사용**: 많은 샘플을 수집하면 메모리 사용량 증가
4. **개인정보**: 프로파일 파일에는 함수 이름과 스택 정보만 포함됨 (사용자 데이터 없음)

## 💡 팁

- 프로파일링은 **성능 최적화가 필요한 시점**에만 활성화하세요
- **여러 번 측정**하여 일관된 결과를 확인하세요
- **다양한 시나리오**를 테스트하여 전체적인 성능 파악하세요
- FlameGraph에서 **넓은 블록**이 시간을 많이 소비하는 함수입니다

