typedef JsonObject = Map<String, dynamic>;
typedef FromJson<T> = T Function(JsonObject json);
typedef ToJson<T> = JsonObject Function(T value);
