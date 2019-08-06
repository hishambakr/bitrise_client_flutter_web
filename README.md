# bitrise_client_flutter_web
Sample website shows flutter web usage: http://bitrise_d.surge.sh

As I can't share company info, you need to update file: /bitrize_client_web/lib/build_time.dart 

```
"Authorization":"<Replace>"
app_android_main = "<Replace>"
app_ios_main = "<Replace>"
workflow_primary_local = "<Replace>"
  ```
then install flutter web following: https://github.com/flutter/flutter_web


then in command line write:

```
cd bitrize_client_web
flutter pub upgrade
webdev serve
```
