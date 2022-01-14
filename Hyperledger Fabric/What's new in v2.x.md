# 개요
What's new in v2.x 번역  
https://hyperledger-fabric.readthedocs.io/en/release-2.4/whatsnew.html

# What's new in Hyperledger Fabric v2.x
## What's new in Hyperledger Fabric v2.4
### Fabric Gateway

### Peer node unjoin

### Calculate package ID of a packaged chaincode

### ‘Chaincode as a service’ builder delivered with fabric-peer image

## What’s New in Hyperledger Fabric v2.3

### Orderer channel management without a system channel

### Ledger snapshot

## What’s New in Hyperledger Fabric v2.0, v2.1, v2.2
Hyperledger Fabric v2.0은 사용자 및 운영자에게 중요한 새로운 기능과 변경사항들을 제공합니다. (새로운 응용프로그램, 개인정보보호 패턴, 스마트 컨트랙트와 관련된 향상된 거버넌스(governance), 노드운영을 위한 신규 옵션 등)

v2.1과 v2.2는 v2.0 릴리즈를 기반으로 신규 마이너 기능들, 버그 수정을 포함하여 만들어 졌습니다. v2.2 버전은 Fabric v2.x의 첫번째 Long-term support(LTS) 릴리즈입니다. 버그수정은 다음 LTX 릴리즈전까지 v2.2.x 릴리즈로 제공되어집니다.

Fabric v2.0 릴리즈의 주요사항들을 살펴봅시다.

### 스마트 컨트랙트의 탈중앙화 거버넌스 - Decentralized governance for smart contracts

Fabric v2.0은 "스마트 컨트랙트의 탈중앙화 거버넌스"를 위해서 chaincode를 peer-node들에 설치하고 channel에서 시작하기 위한 새로운 프로세스를 제공합니다. 새로운 Fabric 체인코드 생명주기(chaincode lefcycle)를 통해서 여러 조직(organization)이 원장(ledger)과 상호 작용하는데 사용되기 전에 체인코드 보증 정책(chaincode endorsement policy)과 같은 체인코드 매개변수에 동의하는데 참여할 수 있습니다. 새 모델은 이전과 비교해서 몇 가지 개선 사항을 제공합니다.

* **여러 조직이 체인코드의 매개변수에 동의 필요** (Multiple organizations must agree to the parameters of a chaincode)  
Fabric v1.x에서는 단일 조직이 단독으로 모든 채널 구성원(member)에 대해서 체인코드의 파라미터(예: 보증 정책)를 설정할 수 있었습니다. 다른 멤버들은 오직 체인코드가 설치되는 것을 거부할 수만 있고, 이 결과 트랜잭션 호출에 참여하지 않습니다. 새로운 Fabric 체인코드 생명주기는 좀 더 유연하게 기존의 "중앙화된 모델(이전 생명주기 모델)" 및 "탈중앙화된 모델"을 지원하게 되었습니다. 탈중앙화된 모델은 체인코드가 채널에서 활성화 되기전에 보증 정책 및 기타 세부 사항에 동의하는 충분한 수의 조직이 필요합니다.

* **보다 신중한 체인코드 업그레이드 프로세스** (More deliberate chaincode upgrade process)  
이전 체인코드 생명주기에서는 단일 조직에서 업그레이드 트랜잭션(transaction)을 발행하여 아직 새 체인코드를 설치하지 않은 채널 구성원에게 위험을 초래할 수 있었습니다. 새 모델을 사용하면 충분한 수의 조직에서 업그레이드를 승인한 후에만 체인코드를 업그레이드할 수 있습니다.

* **더 간단한 보증 정책 및 비공개 데이터 콜렉션 업데이트** (Simpler endorsement policy and private data collection updates)  
Fabric 생명주기는 체인코드의 '재패키지(repackage)' 또는 '재설치(reinstall)'없이 보증 정책(endorsement policy) 또는 비공개 데이터 콜렉션(private data collection)을 변경할 수 있습니다. 사용자는 채널 조직들의 과반수를 요구하는 새로운 기본 보증 정책을 사용할 수 있습니다. 이 정책은 채널에 조직들 추가되거나 삭제될 때 자동으로 업데이트됩니다.

* **검사가능한 체인코드 패키지** (Inspectable chaincode packages)  
Fabric 생명주기는 체인코드를 읽기 쉬운 tar 파일로 패키징합니다. 이를 통해 체인코드 패키지 검사 및 여러 조직에서의 설치를 조정하는 것을 쉽게합니다.

* **하나의 패키지를 사용하여 한 채널에서 여러 체인코드를 시작** (Start multiple chaincodes on a channel using one package)  
이전 생명주기는 체인코드 패키지가 설치(install)될 때 정의된 이름(name)과 버전(version)을 사용해서 채널의 각 체인코드를 정의하였습니다. 이제는 하나의 체인코드 패키지를 사용하여 동일한 채널이나 다른 채널에서 다른 이름으로 여러 번 배포할 수 있습니다. 예를 들면, 체인코드의 '사본'으로 다양한 유형의 자산을 추적하려는 경우 입니다.

* **채널 멤버간 체인코드 패키지 동일 불필요** (Chaincode packages do not need to be identical across channel members)  

조직은 체인코드를 확장할 수 있습니다. 예를 들면, 조직의 이익을 위해서 다른 유효성 검사를 수행하는 것입니다. 필요한 수의 조직이 일치하는 결과로 체인코드 트랜잭션을 승인하면 트랜잭션은 검증되고 원장에 커밋(commit)됩니다. 이를 통해 조직은 전체 네크워크가 단계적으로 진행하지 않고도 자체 일정에 따라 마이너 수정 사항을 개별적으로 배포(roll-out)할 수 있습니다.



# Glossary
* private data : 비공개 데이터


# Reference
* https://bysssss.tistory.com/152