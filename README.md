# OpenJLabel.ts
Bun向けのOpenJLabelです

## 使い方
examples を参考にしてください  

## ビルド
Dockerを使用してビルドします  
```
# DockerでWASMをビルド
$ docker compose build --no-cache
$ docker compose up -d
$ docker compose exec app bash
$ /workspace/build-wasm.sh
$ exit
$ docker compose down
```

## ライセンス
Copyright (c) 2024 KoharuYuzuki  
MIT License (https://opensource.org/license/mit/)  

## サードパーティーライセンス
ThirdPartyNotices.txt をお読みください  
