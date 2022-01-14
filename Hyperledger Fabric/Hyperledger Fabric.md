# 개요
허가 받은 이들에게만 허용되는” 프라이빗 블록체인 네트워크

Linux Foundation의 오픈소스 프로젝트인 Hyperledger Fabric은 엔터프라이즈 블록체인 플랫폼을 위한 모듈형 블록체인 프레임워크인 동시에 사실상의 표준입니다. 엔터프라이즈급 애플리케이션 및 산업용 솔루션을 개발하기 위한 토대로서 만들어진 이 개방형의 모듈형 아키텍처는 플러그앤플레이 구성요소를 사용하여 매우 다양한 유스케이스를 수용합니다.

Hyperledger Fabric은 IBM이 주도하고 있다.

# 주요 특성 (Key Characteristics)
* 고성능 (High-performance)
* 보안 (secure)
* 허가된 블록체인 네트워크 (permissioned blockchain network)
* Go 언어로 개발 (Code written in Go)
* 체인코드(스마트 컨트랙트)를 Go, javascript, Java로 개발가능 (chaincode (smart contracts) in Go, Javascript, or Java)
* SDK를 Node.js, Java, Go, REST 및 Python로 제공 (SDKs in Node.js, Java, Go, REST and Python.)

# 국내 업체
루니버스

UDC 2021 DAY 1  
Enterprise Blockchain and Reg tech : https://youtu.be/hRzPR2jQSaY

# 2.0 

## Hyperledger Fabric v2.0: 새로운 기능
https://pt.slideshare.net/hlkug/hyperledger-fabric-v20

|구 분|기 존|변 경|
|------|---|---|
|체인코드|① peer 별 설치 후 instantiage|Decentralized goveranance 생성<br/> endorsement policy와 같은 life cycle에 의해 관리|
||② docker container로만 관리|외부 런처도 사용 가능하도록 변경<br />(external service)|
||③ shim package 포함|github dir 이동<br />github.com/hyperledger/fabric-chaincode-go/shim|
|golang|④ version 1.11.x 이상|version 1.13.4로 업데이트|
|orderer|⑤ 'Solo, Kafka, Raft' 합의 알고리즘 존재|'Raft' 합의 알고리즘만 사용 가능|

출처 - 어다희님, Hyperledger Korea User Group

③ ccenv 빌드 이미지에 더 이상 shim이 포함되지 않음
- 이에 따라, golang의 의존성 관리 툴인 'go Module'을 활용하여 개발해야 함.

|구 분|코 드|
|------|---|
|① 패키지 초기화|$ go mod init <모듈이름><br />-> go.mod라는 파일이 생성됨|
|② compile|$ go build <파일이름> <br />-> go.mod에 있는 필요한 package들이 생성되며 체인코드 기반의 실행파일 생성|
|참고 = vendor 디렉토리 생성|$ go mod vendor|

- repository 변경 세부사항

|구 분|변경 전|변경 후|
|------|---|---|
|shim|https://github.com/hyperledger/fabric-chaincode-go/tree/main/shim|https://github.com/hyperledger/fabric-chaincode-go/tree/main/shim|
|peer|https://github.com/hyperledger/fabric/protos/peer|https://github.com/hyperledger/fabric-protos-go/tree/main/peer|
|contract||https://github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi|

* contractapi에 shim과 peer가 포함되어있기 때문에 2.0.0-beta에서부터는 contractapi 사용

### 새로운 기능
* Chaincode
  * New Chaincode Lifcylce
  * External Chaincode Launcher
* Private Data Collections enhancements
  * Sharing and verifying private data
  * Collection-level endorsement policies
  * Implicit per-organization collections
* Security and performance improvements
  * State database cache for CouchDB
  * Alpine-based docker images

### Chaincode :: New Chaincode Lifecycle
https://kctheservant.medium.com/first-attempt-on-chaincode-operation-in-hyperledger-fabric-release-2-0-833cab62ba3

![A rough side-by-side illustration on chaincode operation of both releases.](https://miro.medium.com/max/2400/1*0OWshKKq7Wq1mIMYFn04yg.png)

1. packaging(Selected Peer) : 체인코드와 메타데이터의 패키지 파일(tar 파일) 생성. 패키지에는 label이 부여된다. 이를 통해 Organization들간 동일 체인코드 임을 확인할 수 있다.
2. installation(Selected Peer) : 패키지 파일이 선택된 Peer에 설치된다. 채널에 commit 되지 않은 체인코드는 아직 사용할 수 없다. installation의 결과는 <label>.<hash> 형태의 package identifier(Package ID)이다.
3. approval by organizations(Channel): 2.0 이전에는 한 조직(organization)이 체인코드의 "instaniate"(2.0의 commit)를 할 수 있었습니다. 하지만 2.0에서 체인코드는 조직들의 명시적 승인이 요구됩니다. 필요한 조직 수는 수명 주기 보증 정책(lifecycle endorsement policy)(기본 정책은 과반수(majority))에 따라 결정(govern)됩니다.  
승인이 이루어지면 체인코드를 배포할 채널을 지정해야 합니다. 또한 보증 정책(endorsing policy), Init() 코드 존재여부 등과 같은 정보가 필요합니다.
4. chaincode commit(Channel) : 임의의 조직에 의해 시작됩니다. 프로세스는 먼저 조직에게 체인코드가 승인되었다는 보증(endorsement)을 요구합니다. 그 다음 트랜잭션이 순서 서비스(ordering service)에 제출(submit) 후, 새 블록이 생성되고 모든 피어가 이를 원장(ledger)에 커밋(commit)합니다.  
이제 체인코드 수명 주기가 완료되었으며 체인코드를 사용할 준비가 되었습니다. 즉, 체인코드 기능을 호출하고 쿼리할 수 있습니다.

Init() 에 대한 참고 사항 : Init() 에는 호출할 다른 함수보다 먼저 실행될 코드가 포함되어 있으며 처음 한 번만 실행할 수 있습니다. 1.4에서는 체인코드가 인스턴스화될 때 Init()가 실행됩니다. 2.0에서는 체인코드 커밋 후에 명시적으로 Init()를 호출해야 합니다. 승인 및 체인 코드 커밋 중에 Init() 요구 사항을 지정합니다. 또한 Init() 을 호출할 때까지 다른 함수를 호출할 수 없습니다.

### Chaincode :: Chaincode Lifecycle Demo
SACC - Simple Asset Chaincode  
https://github.com/hyperledger/fabric-samples/tree/main/chaincode/sacc

```
func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {
	// Get the args from the transaction proposal
	args := stub.GetStringArgs()
	if len(args) != 2 {
		return shim.Error("Incorrect arguments. Expecting a key and a value")
	}

	// Set up any variables or assets here by calling stub.PutState()

	// We store the key and the value on the ledger
	err := stub.PutState(args[0], []byte(args[1]))  // 강조
	if err != nil {
		return shim.Error(fmt.Sprintf("Failed to create asset: %s", args[0]))
	}
	return shim.Success(nil)
}

// Invoke is called per transaction on the chaincode. Each transaction is
// either a 'get' or a 'set' on the asset created by Init function. The Set
// method may create a new asset by specifying a new key-value pair.
func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
}

// Set stores the asset (both key and value) on the ledger. If the key exists,
// it will override the value with the new one
func set(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 2 {
		return "", fmt.Errorf("Incorrect arguments. Expecting a key and a value")
	}

	err := stub.PutState(args[0], []byte(args[1]))  // 강조
	if err != nil {
		return "", fmt.Errorf("Failed to set asset: %s", args[0])
	}
	return args[1], nil
}

// Get returns the value of the specified asset key
func get(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 1 {
		return "", fmt.Errorf("Incorrect arguments. Expecting a key")
	}

	value, err := stub.GetState(args[0])  // 강조
	if err != nil {
		return "", fmt.Errorf("Failed to get asset: %s with error: %s", args[0], err)
	}
	if value == nil {
		return "", fmt.Errorf("Asset not found: %s", args[0])
	}
	return string(value), nil
}
```

### Chaincode :: External Chaincode Launcher
http://www.bchainledger.com/2020/03/whats-new-in-hyperledger-fabric-v20.html

* v1.x 에서는..
  * Chaincode Launcher는 Peer 구현된 기능에 영향 받음.(Go, Java BUilder)
  * Chaincode를 빌드하거나 실행하기 위해서 Docker Daemon 접근 권한 필요.
  * 사용자는 컨테이너 이외 환경에서 Chaincode 실행할 수 없음.
  * 사용자는 다른 컨테이너 런타임 또는 쿠버네티스와 같은 프레임워크 사용 할 수 없음.
* v2.x에서는 External Chaincode Launcher 기능을 통해 보완.

#### Chaincode Launcher in v1.x -- Drawbacks
* Chaincode launcher was part of the peer implementation
  * Language specific builder
  * Difficult to extend or customize
* Required docker to be part of the deployment environment
  * Privileged access is required to start a peer
* User cannot run the chaincode outside container
* User cannot use a diffrent container runtime or a framework such as Kubernetes

#### Chaincode Launcher in v2.0 - External Builder
* A new config option in core.yaml for the extenrnal chaincode builder
```
chaincode:
  eternalbuilders:
  - name: my-golang-builder
    path: /builders/golang
    environmentWhitelist:
    - GOPROXY
    - GONOPROXY
    - GOSUMDB
    - GONOSUMDB
  - name: noop-builder
    path: /builders/binary
```
* /builder/golang/bin should have the following four executables
  1. detect : Determine whether or not this buildpack should be used to the chaincode package and launch it.
  2. build : Transform the chaincode package into executable chaincode.
  3. release : Provide metadata to the peer about the chaincode.
  4. run : Run the chaincode.
* Chaincode package
```
$ tar xvfz myccpackage.tgz
metadata.json
code.tar.gz
```

bin/detect CHAINCODE_SOURCE_DIR CHAINCODE_METADATA_DIR  
bin/build CHAINCODE_SOURCE_DIR CHAINCODE_METADATA_DIR BUILD_OUTPUT_DIR  
bin/release BUILD_OUTPUT_DIR RELEASE_OUTPUT_DIR  
bin/run BUILD_OUTPUT_DIR RUN_METADATA_DIR

#### Chaincode Launcher in v2.0 - CC(ChainCode) as an External Service

connection.json to be passed in the chaincode package and placed in the RELEASE_OUTPUT_DIR
```
{
  "address": "your.chaincode.host.com:9999",
  "dial_timeout": "10s",
  "tls_required": "true",
  "client_auth_required": "true",
  "client_key": "-----BEGIN EC PRIVATE KEY----- ... ----END EC PRIVATE KEY-----",
  "client_cert": "-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----",
  "root_cert": "-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----"
}
```

```
func main() {
  // The ccid is assigned to the chaincode on install (using the "peer lifecylce ch)
  ccid := "mycc:fcbf8724572d42e859a7dd9a7cd8e2efb84058292017df6e3d89178b64e6c831"

  server := &shim.ChaincodeServer{
                  CCID: ccid,
                  Address: "myhost:9999",  // Chaincode should be started as a service with listen address
                  CC: new(SimpleChainCode),
                  TLSProps: shim.TLSProperties{  // Shim.ChaincodeServer is supported only in go shim
                          Disabled: true,
                  }
          }
  err := server.Start()
  if err != nil {
          fmt.Printf("Error starting Simple chaincode: %s", err)
  }
}
```

### Private Data Enhancement :: Read-Write access control on collections
* v1.x 에서는 체인코드가 적절한 접근제한 없이 작성되었다면 임의의 채널 맴버가 collection에 읽기 쓰기를 할 수 있다.  
![Read-Write Access Control on Collections v1.x](./imgs/HyperledgerFabric/read-write-access-control-on-collections-v1.png)

* v2.x에서는 collection 설정에 다음 설정을 포함한다.
  ![Read-Write Access Control on Collections v2.x](./imgs/HyperledgerFabric/read-write-access-control-on-collections-v2.png)
  * Bool: memberOnlyRead
  * Bool: memberOnlyWrite  


### Private Date Enhancement :: Sharing and verifying private date & Implicit Collection
* 신규 chaincode API - GetPrivateDataHash()
  * private 데이터가 on-chain hash와 일치하는지 검증
  * private data를 다른 collection으로 이동
* 조직별 묵시적 collection (Implicit collection per organization)
  * Pirvate data collection with membership = own organization  
  ![Implicity Collection](./imgs/HyperledgerFabric/implicit-collection.png)

### Security and performance improvements
* Cache for StateDB - CouchDB
  * Endorsement 중에 getState() 함수 호출하는 경우 캐싱
  * MVCC 중에 Cache Hit 발생
  * 10% 성능 향상
* Alpine Linux for Docker Images
  * A Security-oriented, lightweight Linux distribution
  * 보안 취약점 감소


## 하이퍼레저 패브릭, 개선된 버전 2.0 출시
https://kr.cointelegraph.com/news/ibm-backed-hyperledger-fabric-releases-version-20

버전 2.0은 체인코드(chaincodes: 패브릭에서 스마트 컨트랙트를 가리키는 용어)를 위한 새로운 관리 시스템을 추가함으로써 탈중앙화 특징을 크게 개선했다. 따라서 이제는 여러 조직들이 체인코드의 주요 매개변수에 합의한 뒤 이를 공유 원장에 이용할 수 있게 되었다.

또한, 체인코드를 단일 조직에서 조정한 뒤에 원장에 반영할 수 있으므로, 서로간에 공유 가능한 데이터에 대해 모두가 동의할 수 있다.

데이터 공유도 지식 한정(need-to-know)의 원칙에 따라 효율화되었다. 조직들은 이제 데이터를 밀접한 네트워크의 특정 구성원들과 비밀스럽게 공유할 수도 있으므로 이를 위해 복잡한 채널 조합을 정의할 필요가 없다.

끝으로, 업무의 병렬화와 보다 효율적인 프로그램 흐름을 비롯한 몇 가지 성능 개선도 이루어졌다. 하이퍼레저는 이를 통해 해당 네트워크가 초당 수천 건의 거래를 지원할 수 있다고 주장하고 있다.

## IBM, ‘하이퍼레저 패브릭 2.0’ 조만간 업그레이드
https://www.tvcc.kr/article/view/7156

하이퍼레저 패브릭은 IBM이 리눅스 재단에 소스코드를 제공해 만든 기업용 블록체인이다. 현재 스마트컨트랙트 거버넌스가 중앙화되어 있어 한 거래자만 새로운 변수를 제안할 수 있다.

하지만 이번 업그레이트를 통해 스마트컨트랙스 거버넌스가 변경된다. 이전에 제안을 수용하거나 거절하고 진행 중인 거래에서 나가는 두 가지 옵션밖에 주어지지 않았던 참여자에게 스마트컨트랙트 변수를 제안하고 수정할 수 있는 탈중앙화된 거버넌스 옵션을 제공할 예정이다.

또한 제안자가 마음대로 신규 변수를 활성화하는 대신, 결정에 필요한 정원이 변경사항을 승인해야 하는 기능도 추가로 지원한다. 이를 통해 전체적인 성능과 데이터 프라이버시를 개선하고 보안과 유용성을 더욱 높일 계획이다.

# Glossary
* shim: Package shim provides APIs for the chaincode to access its state variables, transaction context and call other chaincodes. https://pkg.go.dev/github.com/hyperledger/fabric-chaincode-go/shim

# Reference
* Hyperledger Fabric: https://www.hyperledger.org/use/fabric
* Document: https://hyperledger-fabric.readthedocs.io/en/latest/
* Code: https://github.com/hyperledger/fabric#releases
* Wiki: https://wiki.hyperledger.org/display/fabric
* IBM - Hyperledger Fabric이란?: https://www.ibm.com/kr-ko/topics/hyperledger
* Awesome Blockchain Kor - 모두를 위한 블록체인: https://github.com/yunho0130/awesome-blockchain-kor
* What’s new in Hyperledger Fabric v2.x: https://hyperledger-fabric.readthedocs.io/en/latest/whatsnew.html
* [Hyperledger Fabric v2.x] #1. 소개 + 실습 환경 구성: https://namho46.tistory.com/19


① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮