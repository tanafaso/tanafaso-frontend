class Status {
  // errorMessage can be empty if the code is API_SUCCESS.
  String errorMessage;
  int code;

  static const int API_SUCCESS = 1000000;
  static const int API_USER_ALREADY_LOGGED_IN_ERROR = 1;
  static const int API_EMAIL_PASSWORD_COMBINATION_ERROR = 2;
  static const int API_LOGIN_WITH_EMAIL_ERROR = 3;
  static const int API_EMAIL_NOT_VERIFIED_ERROR = 4;
  static const int API_USER_ALREADY_REGISTERED_ERROR = 5;
  static const int API_USER_ALREADY_REGISTERED_WITH_FACEBOOK = 6;
  static const int API_PIN_ALREADY_SENT_TO_USER_ERROR = 7;
  static const int API_EMAIL_ALREADY_VERIFIED_ERROR = 8;
  static const int API_VERIFICATION_ERROR = 9;
  static const int API_AUTHENTICATION_WITH_FACEBOOK_ERROR = 10;
  static const int API_SOMEONE_ELSE_ALREADY_CONNECTED_ERROR = 11;
  static const int API_AUTHENTICATION_ERROR = 12;
  static const int API_GROUP_NOT_FOUND_ERROR = 13;
  static const int API_NOT_GROUP_MEMBER_ERROR = 14;
  static const int API_CHALLENGE_NOT_FOUND_ERROR = 15;
  static const int API_NON_GROUP_MEMBER_ERROR = 16;
  static const int API_INCREMENTING_LEFT_REPETITIONS_ERROR = 17;
  static const int API_NON_EXISTENT_SUB_CHALLENGE_ERROR = 18;
  static const int API_MISSING_OR_DUPLICATED_SUB_CHALLENGE_ERROR = 19;
  static const int API_CHALLENGE_EXPIRED_ERROR = 20;
  static const int API_REQUIRED_FIELDS_NOT_GIVEN_ERROR = 21;
  static const int API_DEFAULT_ERROR = 22;
  static const int API_GROUP_INVALID_ERROR = 23;
  static const int API_USER_ALREADY_MEMBER_ERROR = 24;
  static const int API_USER_NOT_INVITED_ERROR = 25;
  static const int API_NOT_MEMBER_IN_GROUP_ERROR = 26;
  static const int API_INVITED_USER_INVALID_ERROR = 27;
  static const int API_INVITING_USER_IS_NOT_MEMBER_ERROR = 28;
  static const int API_INVITED_USER_ALREADY_MEMBER_ERROR = 29;
  static const int API_USER_ALREADY_INVITED_ERROR = 30;
  static const int API_NOT_MEMBER_ERROR = 31;
  static const int API_ERROR_USER_NOT_FOUND = 32;
  static const int API_USER_NOT_FOUND_ERROR = 33;
  static const int API_FRIENDSHIP_ALREADY_REQUESTED_ERROR = 34;
  static const int API_ADD_SELF_ERROR = 35;
  static const int API_NO_FRIENDSHIP_ERROR = 36;
  static const int API_SEARCH_PARAMETERS_NOT_SPECIFIED = 37;
  static const int API_NO_FRIEND_REQUEST_EXIST_ERROR = 38;
  static const int API_FRIEND_REQUEST_ALREADY_ACCEPTED_ERROR = 39;
  static const int API_PAST_EXPIRY_DATE_ERROR = 40;
  static const int API_MALFORMED_SUB_CHALLENGES_ERROR = 41;
  static const int API_EMPTY_GROUP_NAME_ERROR = 42;
  static const int API_EMAIL_NOT_VALID_ERROR = 43;
  static const int API_NAME_EMPTY_ERROR = 44;
  static const int API_PASSWORD_CHARACTERS_LESS_THAN_8_ERROR = 45;
  static const int CHALLENGE_CREATION_DUPLICATE_ZEKR_ERROR = 46;
  // static const int INVALID_RESET_PASSWORD_TOKEN_ERROR = 47;
  static const int ONE_OR_MORE_USERS_NOT_FRIENDS_ERROR = 48;
  static const int LESS_THAN_TWO_FRIENDS_ARE_PROVIDED_ERROR = 49;
  static const int DUPLICATE_FRIEND_IDS_PROVIDED_ERROR = 50;
  static const int CHALLENGE_HAS_ALREADY_BEEN_FINISHED = 51;
  static Map<int, String> conversions = const {
    API_USER_ALREADY_LOGGED_IN_ERROR: "لقد قمت بتسجيل الدخول بالفعل",
    API_EMAIL_PASSWORD_COMBINATION_ERROR:
        "خطأ في تأكيد كلمة مرور البريد الإلكتروني",
    API_LOGIN_WITH_EMAIL_ERROR: "خطأ أثناء تسجيل الدخول",
    API_EMAIL_NOT_VERIFIED_ERROR: "لم يتم التحقق من هذا البريد الإلكتروني",
    API_USER_ALREADY_REGISTERED_ERROR:
        "تم تسجيل هذا المستخدم بالفعل في وقت سابق",
    API_USER_ALREADY_REGISTERED_WITH_FACEBOOK:
        "تم تسجيل هذا المستخدم مسبقًا باستخدام الفيسبوك",
    API_PIN_ALREADY_SENT_TO_USER_ERROR:
        "تم بالفعل إرسال الرمز لهذا المستخدم من قبل",
    API_EMAIL_ALREADY_VERIFIED_ERROR:
        "تم التحقق من هذا البريد الإلكتروني بالفعل من قبل",
    API_VERIFICATION_ERROR: "خطأ أثناء التحقق",
    API_AUTHENTICATION_WITH_FACEBOOK_ERROR:
        "خطأ أثناء تسجيل الدخول باستخدام الفيسبوك",
    API_SOMEONE_ELSE_ALREADY_CONNECTED_ERROR:
        "اتصل شخص آخر بالفعل بنفس الحساب من قبل",
    API_AUTHENTICATION_ERROR: "خطأ أثناء المصادقة",
    API_GROUP_NOT_FOUND_ERROR: "المجموعة غير موجودة",
    API_NOT_GROUP_MEMBER_ERROR: "ليس عضوا في المجموعة",
    API_CHALLENGE_NOT_FOUND_ERROR: "التحدي غير موجود",
    API_NON_GROUP_MEMBER_ERROR: "ليس عضوا في المجموعة",
    API_INCREMENTING_LEFT_REPETITIONS_ERROR:
        "خطأ أثناء تحديث التكرارات المتبقية",
    API_NON_EXISTENT_SUB_CHALLENGE_ERROR: "خطأ أثناء تحديث التكرارات المتبقية",
    API_MISSING_OR_DUPLICATED_SUB_CHALLENGE_ERROR:
        "خطأ أثناء تحديث التكرارات المتبقية",
    API_CHALLENGE_EXPIRED_ERROR: "انقضى الموعد النهائي للتحدي",
    API_REQUIRED_FIELDS_NOT_GIVEN_ERROR: "بعض البيانات المطلوبة مفقودة",
    API_DEFAULT_ERROR: "حدث خطأ ، يرجى المحاولة مرة أخرى",
    API_GROUP_INVALID_ERROR: "هذه المجموعة غير موجودة",
    API_USER_ALREADY_MEMBER_ERROR: "هذا المستخدم عضو بالفعل في المجموعة",
    API_USER_NOT_INVITED_ERROR: "المستخدم غير مدعو لهذه المجموعة",
    API_NOT_MEMBER_IN_GROUP_ERROR: "المستخدم ليس عضوا في هذه المجموعة",
    API_INVITED_USER_INVALID_ERROR: "المستخدم المدعو غير موجود",
    API_INVITING_USER_IS_NOT_MEMBER_ERROR:
        "المستخدم الذي يقوم بالدعوة ليس عضوًا في المجموعة",
    API_INVITED_USER_ALREADY_MEMBER_ERROR:
        "هذا المستخدم عضو بالفعل في المجموعة",
    API_USER_ALREADY_INVITED_ERROR: "تمت دعوة هذا المستخدم من قبل",
    API_NOT_MEMBER_ERROR: "المستخدم ليس عضوا",
    API_ERROR_USER_NOT_FOUND: "لم يتم العثور على المستخدم",
    API_USER_NOT_FOUND_ERROR: "لم يتم العثور على المستخدم",
    API_FRIENDSHIP_ALREADY_REQUESTED_ERROR: "تم بالفعل طلب الصداقة من قبل",
    API_ADD_SELF_ERROR: "لا يمكنك إضافة نفسك",
    API_NO_FRIENDSHIP_ERROR: "لا توجد صداقة",
    API_SEARCH_PARAMETERS_NOT_SPECIFIED: "حدث خطأ ، يرجى المحاولة مرة أخرى",
    API_NO_FRIEND_REQUEST_EXIST_ERROR: "لا يوجد طلب صداقة",
    API_FRIEND_REQUEST_ALREADY_ACCEPTED_ERROR: "تم قبول طلب الصداقة هذا من قبل",
    API_PAST_EXPIRY_DATE_ERROR: "حدث خطأ ، يرجى المحاولة مرة أخرى",
    API_MALFORMED_SUB_CHALLENGES_ERROR: "حدث خطأ ، يرجى المحاولة مرة أخرى",
    API_EMPTY_GROUP_NAME_ERROR: "لا يمكن أن يكون اسم المجموعة فارغًا",
    API_EMAIL_NOT_VALID_ERROR: "البريد الإلكتروني غير صحيح",
    API_NAME_EMPTY_ERROR: "لا يمكن أن يكون الاسم فارغًا",
    API_PASSWORD_CHARACTERS_LESS_THAN_8_ERROR:
        "لا يمكن أن تكون كلمة المرور أقل من 8 أحرف",
    CHALLENGE_CREATION_DUPLICATE_ZEKR_ERROR: "يجب ألا يتكرر الذكر",
    // INVALID_RESET_PASSWORD_TOKEN_ERROR : "";
    ONE_OR_MORE_USERS_NOT_FRIENDS_ERROR: "مستخدم واحد أو أكثر ليسوا أصدقاء",
    LESS_THAN_TWO_FRIENDS_ARE_PROVIDED_ERROR: "تم اختيار أقل من صديقين",
    DUPLICATE_FRIEND_IDS_PROVIDED_ERROR: "تم العثور على أصدقاء مكررين",
    CHALLENGE_HAS_ALREADY_BEEN_FINISHED: "تم الانتهاء من التحدي بالفعل من قبل",
  };

  Status(int errorCode) {
    this.code = errorCode;
    if (errorCode == API_SUCCESS) {
      return;
    }
    print("Error with code " + errorCode.toString() + " has occured.");
    if (conversions.containsKey(errorCode)) {
      errorMessage = conversions[errorCode];
    } else {
      errorMessage = conversions[API_DEFAULT_ERROR];
    }
  }

  static Status getDefaultApiErrorStatus() {
    return new Status(Status.API_DEFAULT_ERROR);
  }
}
