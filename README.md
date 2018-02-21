#Moya + HandyJSON + LazyProvider


**What's LazyProvider?**

* Request same url with same parameters multiple times, LazyProvider will use cache after the first.
* Request same url with same parameters thouand times at the same time, it's ok, LazyProvider will manage this.

```GitHub.provider()``` is powerful than ```MoyaProvider<GitHub>()```

**Usage**

```
// HanyJOSN extension with RxSwift
 GitHub.provider().rx
            .request(.userProfile("winddpan"))
            .map(GitHubUserProfile.self)
            .subscribe(onSuccess: { user in
                print("\nname:\(user.name!) id:\(user.id) url:\(user.url!)")
            }) { error in
                print(error.localizedDescription)
            }.disposed(by: bag)
```

```        
// HanyJOSN extension with MoyaResponse
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