https://hyperledger-fabric.readthedocs.io/en/latest/glossary.html

# Member
= Organization

# Membership Service Provider(MSP)
Membership Service Provider는 Hyperledger Fabric 네트워크에 참여하려는 클라이언트와 피어들의 자격증명(crendentail)을 제공하는 시스템의 추상화 컴포넌트를 의미합니다. 클라이언트들은 트랜잭션을 인증(authenticate)하고, 피어들은 트랜잭션 처리 결과(보장(endorsements))를 인증하기 위해서 자격증명을 사용합니다.

# Private Data
인가된 피어의 개인 데이터베이스에 저장된 비공개 데이터. 논리적으로 채널 원장 데이터와는 분리됩니다. 채널상 조직들의 데이터 접근은 private data collection 정의를 통해서 제한됩니다. 인가되지 않은 조직들은 트랜잭션 데이터의 증거로 채널 원장에서 private data의 hash만 확인할 수 있습니다. 개인정보보호를 위해서 Ordering Service로 private data가 아닌 hash 값이 전달됩니다. 이를 통해 private data를 Orderer로부터 보호합니다.

# Private Data Collection (Collection)
채널 상의 다른 조직에게 공개하지 않으면서 둘 이상의 조직간 confidential data를 관리하기 위해서 사용합니다. 컬렉션 정의는 비공개(private) 데이터 세트를 저장할 수 있는 채널의 조직의 하위 집합을 의미합니다. 이 조직들만이 비공개 데이터와 함께 트랜잭션할 수 있음을 의미합니다.

# Ordering Service (= orderer)
= orderer
+
블록내 트랜잭션의 순서를 정하고, 검증(validation) 및 커밋(commit)을 위해 연결된 피어들에게 블럭을 전파하는 정의된 노드 집합입니다. Ordering service는 피어 프로세스와 독립적으로 존재하며, 네트워크의 모든 채널에 대해 first-come-first-serve 기준으로 트랜잭션의 순서를 정합니다. Kafka 및 Raft 뿐아니라 플러그형 구현을 지원하도록 설계되었습니다. 이것은 overfall network에 대한 공통 바인딩 입니다. 여기에는 각 멤버와 연결된 암호화 ID 요소가 포함됩니다. (It is a common binding for the overall network; it contains the cryptographic identity material tied to each Member.)

# Organization (= Member)
조직(Organization)은 블록체인 네트워크 제공자(Provider)에 의해서 블록체인 네트워크 참여를 초대받게 됩니다. 조직은 MSP(Membership Service Provider)를 네트워크에 추가함으로써 네트워크에 참여합니다. 

조직의 트랜잭션 endpoint는 Peer 입니다. 조직의 집합은 컨소시엄(Consortium)을 형성합니다. 네트워크의 모든 조직은 멤버이지만 모든 조직이 컨소시엄의 참여자는 아닐 수 있습니다.

# Peer
원장(ledger)를 유지보수하고, 원장에 읽기/쓰기를 수행하기 위해서 체인코드 컨테이너를 실행하는 네트워크 엔터티(netowrk entity)입니다. 피어(Peer)는 멤버에 의해서 관리됩니다.