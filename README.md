# Flutter Favorite Place

お気に入りの場所を写真と位置情報付きで保存・管理できるFlutterアプリケーションです。

本アプリは Udemy 講座『Flutter & Dart - The Complete Guide』をベースに、個人学習として実装および一部改修を行ったものです。機能追加よりも、コードを理解し自分で実装できることに重点を置いています。

Flutter & Dart - The Complete Guide
https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps

## プロジェクト概要

カメラで撮影した写真、現在地の取得やGoogle Mapsからの位置選択を組み合わせて、お気に入りの場所を記録できます。保存したデータはSQLiteでローカルに永続化されます。


### 主な機能

- 場所の一覧表示・詳細表示
- カメラで写真を撮影して場所に紐付け
- GPS による現在地の取得
- Google Maps 上での位置選択（ロングプレス）
- 座標から住所への逆ジオコーディング
- SQLite によるローカルデータ永続化

## 技術スタック

| カテゴリ       | 技術                               |
|----------------|------------------------------------|
| フレームワーク | Flutter (Dart SDK ^3.9.0)          |
| 状態管理       | Riverpod (flutter_riverpod ^3.0.0) |
| データベース   | SQLite (sqflite ^2.4.2)            |
| 地図           | Google Maps Flutter (^2.13.1)      |
| 位置情報       | location (^8.0.1)                  |
| カメラ         | image_picker (^1.2.0)              |
| HTTP通信       | http (^1.5.0)                      |
| フォント       | Google Fonts (Ubuntu Condensed)    |
| 環境変数       | flutter_dotenv / envied            |

## ディレクトリ構成

```
lib/
├── main.dart              # アプリのエントリーポイント・テーマ設定
├── models/
│   └── place.dart         # Place / PlaceLocation データモデル
├── provider/
│   └── user_places.dart   # Riverpod StateNotifier + SQLite 操作
├── screens/
│   ├── places.dart        # 場所一覧画面（ホーム）
│   ├── add_place.dart     # 場所追加画面
│   ├── place_detail.dart  # 場所詳細画面
│   └── map.dart           # 地図選択画面
└── widgets/
    ├── places_list.dart   # 一覧表示ウィジェット
    ├── image_input.dart   # 写真撮影ウィジェット
    └── location_input.dart # 位置選択ウィジェット
```

## セットアップ

### 前提条件

- Flutter SDK 3.9.0 以上
- Google Maps API キー（Maps SDK / Geocoding API を有効化）

### 手順

1. リポジトリをクローン

```bash
git clone <repository-url>
cd flutter_favorite_place
```

2. `.env` ファイルをプロジェクトルートに作成し、Google Maps API キーを設定

```
API_KEY='your_google_maps_api_key'
```

3. 依存パッケージをインストール

```bash
flutter pub get
```

4. アプリを実行

```bash
flutter run
```

### プラットフォーム固有の設定

#### Android

`android/app/src/main/AndroidManifest.xml` に以下の権限が必要です:

- `ACCESS_FINE_LOCATION` — GPS位置情報の取得
- `ACCESS_COARSE_LOCATION` — おおよその位置情報の取得
- `CAMERA` — カメラでの撮影

#### iOS

`ios/Runner/Info.plist` に以下のキーが必要です:

- `NSLocationWhenInUseUsageDescription` — 位置情報の利用許可
- `NSCameraUsageDescription` — カメラの利用許可
