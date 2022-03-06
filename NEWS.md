# DNH4 0.1.12

* 카테고리 리턴 함수에 cache를 추가하였습니다.
* Add cache on categories function.

# DNH4 0.1.11

* Cran 정책에 맞게 license 파일을 수정했습니다.
* Fix LICENSE file.

# DNH4 0.1.10

* Cran 등록을 위한 수정 버전입니다.
* Tiny change for cran submit

# DNH4 0.1.8

* 다음 뉴스의 댓글 구조가 바뀌어서 `getComment` 함수를 대응 개발 하였습니다. 
* Fix `getComment` function to change site.

# DNH4 0.1.7

# DNH4 0.1.6

* `getAllComment()` 함수의 limit 100 이상 동작시 오류를 수정하였습니다.
* Fix `getAllComment()` of error occurs when request over limit 100.

# DNH4 0.1.5

* `getComment()` 함수의 `df` 변환시 오류를 수정하였습니다.
* `getAllComment()` 함수를 추가하였습니다.

* Fix `getComment()` of error occurs when `df` transform.
* Add `getAllComment()` function.

# DNH4 0.1.4

* `getComment()` 함수의 auth 부분을 수정하였습니다.
* `getComment()` 함수에서 encoding 부분을 지정하였습니다.
* `getContent()` 함수에서 url 체크를 변경하였습니다.

* Fix auth part of `getComment()` function.
* Set encoding to remove message of `getComment()` function.
* Change url check of `getContent()` function.

## DNH4 0.1.3.3

* `getComment()` 함수의 결과에서 `user_icon` 컬럼을 제거하였습니다.
* Removed the `user_icon` column from the result of the `getComment()` function.

## DNH4 0.1.3.2

* `getContent()` 함수내 datetime 객체를 글자수 처리 방식에서 정규식 처리 방식으로 수정하였습니다.
* We modified the datetime object in the `getContent ()` function to the regular expression method in the character processing method.

## DNH4 0.1.3.1

* `getComment()` 함수의 결과에서 `user_url` 컬럼을 제거하였습니다.
* Removed the `user_url` column from the result of the `getComment()` function.

## DNH4 0.1.3

* `getComment()` 함수의 출력이 `data.frame`으로 잘 동작하도록 개선했습니다.
* The output of the `getCommentb()` function has been modified to work with `data.frame`.

## DNH4 0.1.2

* `getComment()` 함수가 댓글이 없을때 `NULL`, 한개 일때, 여러개 일때 동작하도록 개선했습니다. 
* The `getComment ()` function has been improved to work when there are no comments, `NULL`, one, and several.

## DNH4 0.1.1

* `getComment()` 함수에서 `limit` 인자에 `all` 을 사용하면 전체를 가져오도록 추가했습니다.
* In the `getComment()` function we added `all` to the` limit` argument to get the whole comments.

## DNH4 0.1.0

* 패키지에 대한 변경 사항을 추적하는 `NEWS.md` 파일을 추가했습니다.
* 다음 뉴스 덧글을 얻기 위해 `getComment()` 함수를 추가했습니다.
* stringr 패키지의 종속성을 제거했습니다.

* Added a `NEWS.md` file to track changes to the package.
* Added a `getComment()` function to get daum news comments.
* Removed the dependency of the stringr package.

## DNH4 0.0.2

* 다음 뉴스 개편으로 인해 날짜 형식이 조정되어 반영하였습니다. 
* 리다이렉트되는 주소를 확인해서 뉴스 사이트가 아니면 우회합니다.

* The date format was adjusted due to the following news revision.
* Check the redirected address and bypass it if it is not a news site.

## DNH4 0.0.1

* project start
