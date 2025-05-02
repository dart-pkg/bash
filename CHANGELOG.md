# CHANGELOG.md

## 2025.422.1418

- Initial release

## 2025.422.1439

- Changed README.md and source/test files

## 2025.422.1519

- Changed Bash class's constructor parameter runInShell to false

## 2025.422.1758

- Introduced mics project dependencies

## 2025.424.1846

- Removed dependency to misc package

## 2025.426.2233

- Added example/example.md

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-name: "bash"
-description: "Wrapper over `dart:io` [Process] API's that supports additional features."
-version: 2025.424.1846
-homepage: null
+name: bash
+description: Wrapper over `dart:io` [Process] API's that supports additional features.
+version: 2025.426.2233
+homepage:
-  sdk: "^3.7.2"
+  sdk: ^3.7.2
+platforms:
+  android:
+  ios:
+  linux:
+  macos:
+  #web:
+  windows:
-  std: ^2025.424.1835
+  std: ^2025.426.1637
```

## 2025.427.1707

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.426.2233
+version: 2025.427.1707
-  std: ^2025.426.1637
+  std: ^2025.427.52
```

## 2025.428.1728

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.1707
+version: 2025.428.1728
-  std: ^2025.427.52
+  std: ^2025.428.1703
```

## 2025.430.1845

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.428.1728
+version: 2025.430.1845
-  std: ^2025.428.1703
+  std: ^2025.430.1833
```

## 2025.502.924

- Update pacage dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.430.1845
+version: 2025.502.924
-  std: ^2025.430.1833
+  std: ^2025.501.843
```

## 2025.503.28

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.502.924
+version: 2025.503.28
-  std: ^2025.501.843
+  std: ^2025.502.2358
```
