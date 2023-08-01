abstract class AppStates {}

// Login states
class AppLoginInitialState extends AppStates {}

class AppSuccessfulLoginState extends AppStates {}

class AppFailureLoginState extends AppStates {}

class AppEnterSignupState extends AppStates {}

/////////////////////////////////////////////////////

// Signup states

class AppSignupInitialState extends AppStates {}

class AppChangeCheckboxState extends AppStates {}

class AppSelectCompanySizeState extends AppStates {}

class AppSuccessfulSignupState extends AppStates {}

class AppFailureSignupState extends AppStates {}

class AppContinueStepState extends AppStates {}

class AppFailStepState extends AppStates {}

class AppCancelStepState extends AppStates {}

class AppChooseIndustryState extends AppStates {}


/////////////////////////////////////////////

// home

class AppHomeInitialState extends AppStates {}

class AppHomeChangeNavBarState extends AppStates {}

class AppChangeFavState extends AppStates {}

class AppSelectCompanyState extends AppStates {}

class AppChangeCompanyServiceFavState extends AppStates {}
class AppFailureAddState extends AppStates {}
class AppSuccessfulAddState extends AppStates {}
class AppChangeRadioState extends AppStates {}
class AppSuccessfulCalculateDistanceState extends AppStates {}
class AppSuccessfulGetAddressState extends AppStates {}
class AppSuccusfulReturnServicesState extends AppStates {}
class AppSuccusfulReturnCompaniesState extends AppStates {}
class AppDisplayServicesState extends AppStates {}



///////////////////////////////////////////////




// edit profile

class AppEditProfileInitialState extends AppStates {}

class AppSuccessfulUpdateState extends AppStates {}

class AppFailureUpdateState extends AppStates {}

class AppSuccessfulUploadImageState extends AppStates {}

class AppSuccessfulGetLocationState extends AppStates {}

/////////////////////////////////////////////






// Database

class AppInitialState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}

class AppInsertDatabaseState extends AppStates {}

class AppGetDatbaseLoadingState extends AppStates {}

class AppGetFromDatbaseState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}

class AppDeleteDatabaseState extends AppStates {}


///////////////////////////////////////////////


