# Consuming Web Services in iOS

## In-lecture exercise

Update the `name` property in the `ViewModel` class to match your first name (all lowercase, no spaces).

Implement the `execute` method of the struct `HTTPRequestHandler` to handle **GET** requests. To test your implementation run the app in the simulator or on device then click the 🔁 icon.

### Solution

Your finished method should look something like this:

```
func execute(callback: @escaping (Result<Any>) -> Void) {
    guard let url = URL(string: path) else {
        callback(.failure(RequestError.invalidURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    if let headers = headers {
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }

    if let body = body {
        do {
            request.httpBody = try JSONEncoder().encode(body as? ColorData)
        } catch (let e) {
            callback(.failure(e))
        }
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            callback(.failure(error))
            return
        }

        guard let response = response as? HTTPURLResponse else {
            callback(.failure(RequestError.noResponse))
            return
        }

        guard response.statusCode < 400 else {
            callback(.failure(RequestError.httpResponse(response.statusCode)))
            return
        }

        guard let data = data else {
            callback(.failure(RequestError.noData))
            return
        }

        if let str = String(data: data, encoding: .utf8) {
            print("Received response: \(str)")
        }

        do {
            let colorData = try JSONDecoder().decode(ColorData.self, from: data)
            callback(.success(colorData))
        }
        catch {
            callback(.failure(RequestError.decoderFailure))
        }
    }
    task.resume()
}
```

## Post-lecture exercise

Build upon your `execute` function to handle **PUT** requests as well. You can see what the post takes in as arguments in the `ViewModel` class under the `setColor` method. You will need to add header values to and serialize the body data for URLRequest.

To test your implementation, run your app in simulator or on device and select a color from the color picker. The color you picked should appear under your name in the companion web app.

Create a pull request with this updated code for review and feedback.