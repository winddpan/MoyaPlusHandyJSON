## Moya + HandyJSON + LazyProvider


### What's LazyProvider?

* request same url with same parameters multiple times, LazyProvider will use cache after the first.
* request same url with same parameters thousand of times at the same time, it's ok, LazyProvider will manage this.

```MoyaProvider<GitHub>()``` **Moya basic request, without any cache**

```GitHub.provider()``` **Normal request, and cache the response**

```GitHub.lazyProvider()``` **Use cached response if exists, or request and cache the response**

## Swift version
**4.0+**

## CocoaPods

```pod 'MoyaPlusHandyJSON'```

## Usage
<br>

**Create a HandyJSON Model**

```
import Foundation
import HandyJSON

class GitHubUserProfile: HandyJSON {
    var name: String?
    var id: Int = 0
    var url: String?
    
    required init() {}
}
```
<br>

**HanyJOSN extension with RxSwift**

```
 GitHub.provider().rx
            .request(.userProfile("winddpan"))
            .map(GitHubUserProfile.self)
            .subscribe(onSuccess: { user in
                print("\nname:\(user.name!) id:\(user.id) url:\(user.url!)")
            }) { error in
                print(error.localizedDescription)
            }.disposed(by: bag)
```
<br>

**HanyJOSN extension with MoyaResponse**

```        
GitHub.provider()
    .request(.userProfile("winddpan")) { result in
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            let user = try! moyaResponse.map(GitHubUserProfile.self)
            
            print("\nname:\(user.name!) id:\(user.id) url:\(user.url!)")
        // do something with the response data or statusCode
        case let .failure(error):
            // this means there was a network failure - either the request
            // wasn't sent (connectivity), or no response was received (server
            // timed out).  If the server responds with a 4xx or 5xx error, that
            // will be sent as a ".success"-ful response.
            break
        }
}
```
