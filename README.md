# O-G Market

>   중고 또는 새로운 물건을 사람들에게 판매할 수 있는 오픈마켓 앱

<img width="260" alt="재고 유효성 검사" src="https://user-images.githubusercontent.com/73573732/174826069-b190c2c4-38f4-4114-9c2a-2d356b33c176.mov"> <img width="260" alt="상품 등록" src="https://user-images.githubusercontent.com/73573732/174829023-fab181cd-465a-4c2e-ba70-b751b09f8d5d.gif" > <img width="260" alt="상품 수정" src="https://user-images.githubusercontent.com/73573732/174830492-9e9a453d-0e03-4394-9ed6-d2e3190364b5.gif">

<br/>



# 목차

-   [프로젝트 정보](#프로젝트-정보)
-   [기능 및 트러블 슈팅](#기능-및-트러블-슈팅)
    -   [Swift Concurrency 및 Alamofire를 사용하여 네트워크 구현](#Swift-Concurrency-및-Alamofire를-사용하여-네트워크-구현)
        -   [고민 또는 문제점](#고민-또는-문제점)
    -   [UICollectionViewDiffableDataSource를 통한 상품 리스트 구현](#UICollectionViewDiffableDataSource를-통한-상품-리스트-구현)
        -   [고민 또는 문제점](#고민-또는-문제점-2)
    -   [유효성 검사 구현](#유효성-검사-구현)
        -   [고민 또는 문제점](#고민-또는-문제점-3)
    

<br/>



# 프로젝트 정보

-   2인 프로젝트: 글렌(김재현), 오동나무(김동빈)
-   학습 키워드: `Swift Concurrency`, `Coordinator Pattern`, `UICollectionViewDiffableDataSource`, `Alamofire`

<br/> 

# 기능 및 트러블 슈팅

## Swift Concurrency 및 Alamofire를 사용하여 네트워크 구현

프로젝트를 진행하며 네트워크 통신 객체를 3가지 방법으로 구현해봤습니다.

1.   [탈출 클로저와 `Result<Success, Failure>` 타입을 통한 네트워크 통신 구현](https://bit.ly/3y8Y4g3)
2.   [Swift Concurrency의 `async / await` 을 통한 네트워크 통신 구현](https://bit.ly/3tTaGW6)
3.   [Swfit Concurrency를 지원하는 Alamofire 5.5 ↑ 을 통한 네트워크 통신 구현](https://bit.ly/3A9cQVB)

셋 모두를 코드로 작성해보면서 1번과 2번의 길이와 코드 가독성의 차이는 정말 크게 체감됐습니다. [`async / await`을 소개하는 WWDC](https://developer.apple.com/videos/play/wwdc2021/10095/)를 보면서, 많은 문제점들이 존재했고, 그 중에는 겪어본 적이 있어 특히나 공감되는 문제들도 있었습니다. 바로 조건문에서도 실패할 수 있는 상황에서 `completion` 블록을 호출하지 않고 `return` 해버리거나, 그 반대의 상황입니다. 하지만 `async / await`은 `completion`의 동작을 반환 타입으로 변경하여 매개변수를 하나 줄일 수 있어서 네이밍을 깔끔하게 유지할 수 있었습니다. 그리고 사용되는 곳이 `async` 함수 내부라면 바로 `await` 키워드와 함께 바로 사용할 수 있었습니다. 그게 아니라면 `Task<Success, Failure>` 를 통해 간단하게 Concurrency 환경을 제공해주어 그 내부에서 편하게 사용할 수 있었습니다.

아래는 게시글의 상세 정보를 불러오는 코드를 1번 방법을 작성하고, 3번으로 바꾸어 작성해봤습니다. 라이브러리의 힘이 존재하지만 엄청나게 코드의 양을 줄일 수 있었고, 훨씬 더 가독성 있는 모습을 볼 수 있습니다.

```swift
typealias DataTaskCompletion = (Data?, URLResponse? Error?) -> Void
func fetch(details productID: Int, completion: @escaping (Result<Post, Error>) -> Void) {
    let url = try manager.makeProductInquiryURL(productID: productID)
    
    let taskCompletion: DataTaskCompletion = { data, response, error in
        if error != nil, let response = response as? HTTPURLResponse {
            guard (200..<400).contains(response.statusCode) else {
                completion(.failure(error))
                return
            }
        }
                                              
        guard let data = data else { return }
                                              
        do {
            let post = try JsonDecoder().decode(Post.self, from: data)
            completion(.success(post))
        } catch {
            completion(.failure(error))
        }
    }
    
    URLSession.shared.dataTask(with: url, completionHandler: taskCompletion).resume()
}
```

```swift
func fetch(details productID: Int) async throws -> Post {
    let url = try manager.makeProductInquiryURL(productID: productID)
    let response = AF.request(url)
        .validate(statusCode: 200..<400)
        .responseDecodable(of: Post.self) { dataResponse in
            guard dataResponse.error == nil else {
                debugPrint(dataResponse.error!)
                return
            }
        }
        .serializingDecodable(Post.self)

    return try await response.value
}
```

<br/>



### 고민 또는 문제점

|                             고민                             |
| :----------------------------------------------------------: |
| Alamofire을 사용해서 MultiPart 통신을 할 때, 데이터를 더 쉽게 넣어주는 방법은 없을까? |

데이터 통신을 할 때, CRUD 중 Create 부분만 순수 Swift의 `async / await` 을 적용한 채로 두었습니다. 그 이유는 대부분의 예시에서 객체를 `Dictionary<String, Any>` 타입으로 변경하고, 그 객체를 순회하면서 직접 `data(using:)` 메서드를 통해 하나씩 변경하고 있거나, 아래처럼 모든 프로퍼티를 `utf8` 방식으로 일일이 변환하는 방식이었기 때문입니다.

```swift
func upload(contents: Registration) async throws -> Post {
    AF.upload(multipartFormData: { formData in
        formData.append(Data(contents.name.utf8), withName: "ProductName")
        formData.append(Data(contents.descriptions.utf8), withName: "ProductDescription")
        // Code...
    })
}
```

Alamofire를 사용하지 않고 일반적으로 MultiPart 통신에서 데이터를 업로드할 때는, `JSONEncoder`로 인코딩한 결과를 그대로 전달해주었는데, 코드 길이는 당연히 Alamofire가 줄어들지만, 개인적으로는 데이터 전송에 있어서 만큼은 더 불편한 방식을 고수하는 것 같았습니다. 그래서 혹시 `JSONEncoder`로 인코딩을 거치고, Alamofire 방식을 활용하면 가능할까 해서 적용해봤지만, 결과는 실패했습니다. 그래서 추후에 Alamofire를 더 톺아보며, 다른 방법이 있는지 찾아보고 수정하고자 합니다.

|                             고민                             |
| :----------------------------------------------------------: |
| API 주소가 같지만, 하는 일이 다를 때는 메서드를 어떻게 분리해야 할까? |

서버 명세에서 제품 상세 보기와 제품 수정의 API 주소가 아래와 같은 형식으로 동일합니다.

```http
{{api-host}/api/products/{{product_id}}}
```

하지만 명백히 HTTP 메서드도 각각 GET과 PATCH로 다르고, 사용하는 곳도 다릅니다. 저는 `URLManager`라는 객체에서 `URL` 생성을 관리하도록 설계했는데, 처음에는 동작은 다르지만 메서드 결과물이 동일하기 때문에 불필요한 반복을 피해야 한다고 생각해서 네이밍을 `makeProductInquiryOrUpdateURL(productID:)` 와 같이 작성했습니다. 하지만 이런 네이밍은 메서드를 사용하는 곳에서 가독성을 떨어뜨릴 수 있고, 작성자에게 혼란을 줄 수 있다는 생각이 들었습니다. 그래서 결과물은 같지만 명백히 다른 의미를 가진 메서드이기 때문에 분리해서 다음과 같이 작성했습니다:

```swift
func makeProductInquiryURL(productID: Int) throws -> URL { ... }

func makeProductUpdateURL(productID: Int) throws -> URL { ... }
```

[👆 목차로 돌아가기](#목차)

<br/>



## UICollectionViewDiffableDataSource를 통한 상품 리스트 구현

|    메인 뷰의 Refresh 기능과 Infinity Scroll이 구현된 모습    |
| :----------------------------------------------------------: |
| <img width="260" alt="재고 유효성 검사" src="https://user-images.githubusercontent.com/73573732/174826069-b190c2c4-38f4-4114-9c2a-2d356b33c176.mov"> |

iOS 14부터 `UITableView` 대신 `UICollectionView`를 테이블 뷰 형태로 만들 수 있습니다. 그리고 해당 뷰의 셀은 `UICollectionViewListCell`을 통해, 데이터는 `UICollectionViewDiffableDataSource` 로 이전보다 쉽게 데이터를 적용할 수 있었습니다. `UICollectionDiffableDataSource` 핵심 개념인 `Snapshot`이 라는 개념이 처음엔 생소한 듯 했으나, 깃과 동작 원리가 유사하다는 것을 깨닫고, 조금 더 쉽게 이해가 되었습니다. 깃에서는 프로젝트에 변경사항이 발생하면 `add`와 `commit`을 통해 스냅샷을 저장합니다. `UICollectionDiffableDataSource`도 마찬가지로 현재 모습에 대한 사진을 찍어서 저장하고 있다가, 변경사항이 발생하면, `append` 계열의 메서드를 통해 기존 스냅샷을 편집할 수 있고, 그것을 `apply` 로 기존과는 다른 새로운 스냅샷을 찍는다고 이해했습니다.

<br/>



### 고민 또는 문제점

|                            문제점                            |
| :----------------------------------------------------------: |
| 서버에 새로운 데이터가 추가됐고, 기존 뷰에 셀을 추가하려면 어떻게 해야할까? |

RefreshControl을 구현하며, 위를 당겨서 Refresh 동작을 수행할 때 발생해야 하는 동작은,

1.   변경됐을 가능성이 있으므로 페이지에 대한 새로운 데이터를 로드
2.   스냅샷에 새로 생긴 데이터를 추가해서 리로드

하면 된다고 생각했습니다. 그래서 아래와 같이 스냅샷에 바로 추가를 진행했었습니다.

```swift
func refreshCollectionView() {
    // Data fetch logic...
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(page.post)
    await dataSource.applySnapshotUsingReloadData(snapshot)
}
```

동작은 했지만, 데이터를 삭제 후, 새로고침을 하면 삭제된 셀이 사라지지 않고 그대로 남아있는 현상이 생깁니다. 그 이유는 스냅샷에 추가되었던 아이템과 새로 받아온 데이터가 서로 연결되지 않았기 때문입니다. 새로고침은 모든 동작을 처음부터 새로 동작하게 하는 것입니다.

```swift
func refreshCollectionView() {
    // Data fetch logic...
    var snapshot = dataSource.snapshot()
    snapshot.deleteAllItems()
   	snapshot.appendSections([.main])
    snapshot.appendItems(page.post)
    await dataSource.applySnapshotUsingReloadData(snapshot)
}
```

그래서 저는 위와 같이 기존 스냅샷에 존재하던 모든 데이터를 삭제해주고, 받아온 최신의 데이터를 기반으로 새로운 스냅샷을 구성해줬습니다.

|                           고민                           |
| :------------------------------------------------------: |
| 설계에서 UI와 기능 중 어떤 것이 먼저 우선시 되어야 할까? |

초기 프로젝트를 진행할 때, 앱 메인이 예쁘게 보였으면 좋겠다는 생각에 다음과 같이 뷰를 구성하고자 했습니다:

<img width="650" alt="" src="https://user-images.githubusercontent.com/73573732/174876457-a1f8adf6-e0c0-4943-8e30-759ce71a52bb.png">

해당 UI 구현을 위해 뷰를 두 개로 나누어 구현하는 것이 아닌, `UICollectionViewCompositionalLayout`을 통해 한 번에 구현할 수 있었습니다. 하지만 고민해보니 구현해 본 경험은 좋지만, 정말 캐러셀이 필요한지 의문이 들었습니다. 특정 물품을 사용자에게 더 부각하려는 의도나 다른 기능을 위해서 UI를 개발한 것이 아닌, 반대로 UI를 먼저 개발하고 거기에 기능을 끼워맞추는 식이 되어버렸습니다. 이 경험을 계기로, 개발 이전에 기능에 대한 명세와 설계가 충분히 이루어져야 한다는 것을 다시 한 번 느꼈습니다.

[👆 목차로 돌아가기](#목차)

<br/>



## 유효성 검사 구현

일반적으로 사용자는 `UITextField`에 어떤 문자든지 입력이 가능합니다. 하지만 서버와 클라이언트가 통신할 때, 서버에 저장되어야 하는 값은 정해져 있습니다. 서버에서도 유효성 검사가 가능하지만, 그렇게 되면 이미 통신이 한 번 발생하고 난 후에 알 수 있기 때문에 리소스 낭비가 발생할 수 있다고 생각합니다. 그렇기에 클라이언트에서 통신이 일어나기 전에, 서버와 약속한 값만을 사용자가 입력할 수 있도록 유도하는 작업이 필요하다고 생각했습니다.

|                       가격 유효성 검사                       |                       재고 유효성 검사                       |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img width="260" alt="가격 유효성 검사" src="https://user-images.githubusercontent.com/73573732/174802837-ef22dad9-3e2e-4efc-8749-7e6dee953420.gif"> | <img width="260" alt="재고 유효성 검사" src="https://user-images.githubusercontent.com/73573732/174807545-64e176d2-7e9e-45b7-90b4-a84fa0b29a65.gif"> |

가격의 경우, 최대 12자리 (1,000 억)까지 나타낼 수 있게 했습니다. (어떤 기준으로 1,000억을 상한으로 정한 것은 아닙니다...) 그리고 숫자대신 다른 문자가 들어왔을 때는 숫자로 입력할 수 있도록 유도하고 있습니다. 복사 및 붙여넣기를 해도 똑같이 유효성 검사에서 걸러집니다.  해당 유효성 검사는 숫자로 입력했지만 잘못된 문자의 입력이 아니므로, 최대로 작성했던 문자까지 작성된 상태가 유지되는 것이 사용자가 편하게 작성할 수 있다고 판단하여 `textField(_:shouldChangeCharactersIn:replacementString:)` 메서드에 검사 함수를 넣었습니다.

재고의 경우, 최대 8자리 (99,999,999개)까지 나타낼 수 있게 했습니다. (이 기준도 마찬가지 입니다.) 해당 필드도 조건만 다를 뿐 원리는 같습니다. 해당 유효성 검사는 잘못된 입력이므로, 기존 문자를 삭제하고 처음부터 다시 입력하도록 하는 것이 사용자가 편하게 느낄 수 있다고 판단하여 `textFieldDidEndEditing(_:)`에서 함수를 넣었습니다.

위 유효성 검사들은 정규표현식을 사용했습니다. 그리고 해당 경고문의 **OK** 액션을 선택했을 때, 작성해야 하는 필드가 `firstResponder`가 되도록 코드를 작성했습니다.

<br/>



### 고민 또는 문제점

|                             고민                             |
| :----------------------------------------------------------: |
| 클라이언트에서'만' 유효성 검사를 하는 것이 과연 옳은 것일까? |

과거 프로젝트에서, **API키를 숨기는 방법**에 대해서 고민했던 적이 있는데, 이 부분과 마찬가지로 서버에서도 비슷한 흐름으로 보안 문제가 발생할 수 있지 않을까 라는 생각이 들었습니다. 서버도 마찬가지이지만, 클라이언트가 더 보안에 취약하기 때문에, 과연 서버 리소스 절약을 위해 클라이언트에서만 유효성 검사를 하는 것이 맞는가 라는 의문이 들었습니다. 그래서 여러 글을 읽어봤는데, 서버와의 통신 없이 즉각적으로 반응을 나타내 줄 수 있기 때문에 클라이언트에서 유효성 검사가 이루어져야 하는 것이 맞지만, 서버에서도 동일하게 유효성 검사가 이루어 져야하는 것이 좋다는 의견이 많이 있었습니다. [어떤 글에서는](https://jojoldu.tistory.com/129) 많은 유효성 검사가 필요한 경우, 서버에서 공통 모듈을 통해 검사하고, 응답 형태를 클라이언트에서 받아서 메시지를 뿌리는 게 더 좋다는 의견도 있었습니다.

[👆 목차로 돌아가기](#목차)
