# MOSAINFO
실시간 개인정보 모자이크 멀티 스트리밍 애플리케이션 <br/>
Real-time Pixelizing Personal Information Multi-Streaming Application &nbsp;&nbsp;&nbsp;&nbsp;
[<img src="https://img.shields.io/badge/youtube-FF0000?style=for-the-badge&logo=youtube&logoColor=white">](https://www.youtube.com/watch?v=KwK6oQNaHkc)


<div align="center">
<img width="800" alt="mosainfo_logo" src="https://user-images.githubusercontent.com/51855129/219063897-82e78436-e8b4-4e67-84c5-68303a3e0c94.png">
</div>

<br/> 
<br/> 

## 💻 MOSAINFO BACKEND
해당 레포지토리는 MOSAINFO 프로젝트의 프런트엔드(모바일 앱) 개발에 관한 리포지토리입니다.<br/>
[백엔드 리포지토리 바로가기](https://github.com/Hi-DN/mosainfo-backend)

<br/> 

## 🖐 About Project
<div align="center">
<img width="800px" alt="title" src="https://user-images.githubusercontent.com/51855129/219096865-7d469368-8e6e-4918-9e05-8dd2b553579b.png">
</div>

### 실시간 개인정보 모자이크 멀티 스트리밍 애플리케이션
최근 몇년간 인터넷이 급속도로 발전함에 따라 실시간 스트리밍 방송을 제공하는 플랫폼들 역시 크게 성장했습니다. 이는 양날의 검으로, 그 이면에는 심각한 부작용이 존재합니다. 그중 하나로는 “개인정보 노출의 위험성”이 있습니다. 저희는 뉴스와 기사를 통해 최근 몇 년간 인터넷 영상에 개인정보가 노출되어 문제가 된 사례들을 다수 발견할 수 있었습니다. 이러한 개인정보 노출은 범죄로 이어질 가능성이 다분합니다. 추가적으로 일반 영상에 비해, 실시간 스트리밍은 시청자들에게 영상이 즉시 전달되기 때문에 수습할 시간이 주어지지 않아 그 심각성이 더욱 크다고 생각됩니다. 

이를 해결하기 위한 방안으로, 실시간으로 개인정보 모자이크를 진행하는 멀티 스트리밍 애플리케이션을 개발하게 되었습니다.

### 개인정보 모자이크 대상
- 택배 운송장
- 차량 번호판
- 신분증


### Real-time Pixelizing Personal Information Multi-Streaming Application**<br/>
With the rapid development of the Internet in recent years, platforms that provide real-time streaming broadcasting have also grown significantly. It's a double-edged sword with serious side effects behind it. One of them is the "Risk of personal information disclosure." Through news and articles, we have been able to find a number of cases in which personal information has been exposed to Internet video in recent years. This exposure of personal information is likely to lead to crime. In addition, compared to ordinary videos, personal information leak in real-time streaming is considered to be more serious since the video is immediately delivered to the viewers, so they don't have enough time to  handle it.

As a way to solve this problem, we developed a multi-streaming application that mosaic personal information in real time.

### Pixelized Personal Information Target**
- Invoices On Packages
- License Plates
- Id-Cards
<br/> 

## 📅 Duration
2022.02 - 2022.11

<br/> 

## 🔮 Preview
<div align="center">
  <img width="800px" alt="id-card" src="https://user-images.githubusercontent.com/51855129/219111340-8dc28b2e-d17e-4f32-b28f-67139547d787.gif">
  <img width="800px" alt="invoice" src="https://user-images.githubusercontent.com/51855129/219110805-e65a4c60-9db7-4a33-953f-6fabbd86fdc4.gif">
  <img width="800px" alt="license-plate" src="https://user-images.githubusercontent.com/51855129/219112299-c23d4274-ea57-4569-b5a6-bdeff9304808.gif">
</div>

<br/> 

## 🥞 Stacks
### 프런트엔드 (FRONTEND)
- Flutter

### 백엔드 (BACKEND)
- Flask
- Pytorch
- OpenCV
- NginX

### 인공지능 모델 학습 (AI Model Training)
- Yolov5

<br/> 

## 🧱 System Structure

<div align="center">
<img width="800px" alt="Structure" src="https://user-images.githubusercontent.com/51855129/219097667-34686822-302d-4cd0-af19-d5b2c6702266.png">
</div>

1. 스트리머가 플러터 모바일 앱에 접속해서 스트리밍을 시작합니다.
2. 백엔드 Flask 서버에서 이를 요청 받습니다.
3. Flask 서버 내부에서 Pytorch, OpenCV를 통해 개인정보 대상을 인식하고 모자이크를 진행합니다.
4. 개인정보가 보호된 스트리밍을 Rtmp 서버로 내보냅니다.
5. 시청자가 모자이크가 적용된 스트리밍을 앱에서 보게 됩니다.

<br/> 

## 🛝 Structure Internal Details 멀티 스트리밍 구조
내부적으로 모자이크가 진행되는 멀티 스트리밍 구조입니다.
Hi-DN은 여러 명의 사용자가 동시에 스트리밍을 할 수 있도록 각 스트리밍에 고유 아이디를 부여하는 방식을 사용했습니다.
[자세한 설명](https://www.youtube.com/watch?v=KwK6oQNaHkc)
<div align="center">
  <img width="800px" alt="Details" src="https://user-images.githubusercontent.com/51855129/219097816-0605e3db-711b-4c2c-afb3-9089d39ac72b.png">
</div>
 
 </br>

## 🤖 AI Training Details
### 학습 데이터 셋
: 총 약 21000장
  - 택배 운송장: 원본 1200장 × 3배 증폭
  - 차량 번호판: 원본 1107장 × 3배 증폭
  - 신분증: 원본 1141장 × 3배 증폭
  - 백그라운드 이미지: 전체 데이터 셋의 10%

### 인공지능 모델 학습 결과
#### 인식률
  - loss: 1% 미만
  - mAP, precision과 recall: 평균 0.95 이상
<div align="center">
<img width="1641" alt="image" src="https://user-images.githubusercontent.com/51855129/219100375-a86bafc8-5871-41bf-8d10-88949ef7e1e1.png">
</div>


#### Confidence Check & Decision
- precision과 recall 에 대한 결과 그래프를 통해 백엔드에서 모자이크를 진행할 때 사용되는 객체 인식 confidence를 적정선인 0.6으로 결정하였습니다.

<div align="center">
<img width="386" alt="image" src="https://user-images.githubusercontent.com/51855129/219100717-7933df09-2731-426c-a076-cf760d041f10.png"><img width="386" alt="image" src="https://user-images.githubusercontent.com/51855129/219100743-7b28a6f3-dab0-4770-b46e-0be855483e5a.png"><img width="386" alt="image" src="https://user-images.githubusercontent.com/51855129/219100763-3e64295c-3daf-4032-a951-731348ece82b.png"><img width="368" alt="image" src="https://user-images.githubusercontent.com/51855129/219100778-cacc23d0-633c-4e42-9c19-a78930d26a46.png">
</div>

<br/> 

## 🖥 More Details...
MOSAINFO 프로젝트에 대한 더 자세한 설명이 궁금하시다면 다음 유튜브 영상을 참고해주시면 감사하겠습니다 😊 

[유튜브 영상 바로가기](https://www.youtube.com/watch?v=KwK6oQNaHkc)

<br/> 

## 개발팀 소개
|        **TEAM**         |          김민지         |       이한슬         |                                                                                                               
| :---------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | 
|   <img width="200px" src="https://user-images.githubusercontent.com/51855129/219069219-a5dc76bc-6ff0-49e2-b40a-4c41e5f18ef7.png" />    |                      <img width="160px" src="https://user-images.githubusercontent.com/51855129/219071391-b856e91a-88c3-429f-b27e-fe1e2dcbbb1c.png" />    |                   <img width="160px" src="https://user-images.githubusercontent.com/51855129/219068013-42c555f0-220c-4345-bb4e-e7ac9a417925.png"/>   |
|   [![Github](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/Hi-DN)   |    [@minji1110](https://github.com/minji1110)  | [@hanslelee](https://github.com/hanslelee)  |
|  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Hong Ik Domain Name  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  | 2023 홍익대학교 컴퓨터공학과 졸업 | 2023 홍익대학교 컴퓨터공학과 졸업 |

<br/>   
