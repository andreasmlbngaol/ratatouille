class AppRoutes {
  // Auth
  static const splash = "/splash";
  static const signIn = "/sign-in";
  static const signUp = "/sign-up";
  static const completeSetup = "/complete-profile";
  static const emailVerification = "/email-verification";

  // Main
  static const main = "/main";
  static const home = "/main/home";
  static const favorite = "/main/favorite";
  static const myRecipe = "/main/my-recipe";
  static const profile = "/main/profile";
  static const settings = "/main/settings";

  // Search pages
  static const searchRecipe = '/search-recipe';
  static const searchUser = '/search-user';
  static const recipeDetail = "/main/recipe-detail";
  static const createRecipe = "/create-recipe";
  static const createRecipeBaseInfo = "/create-recipe/base-info";
  static const createRecipeIngredients = "/create-recipe/ingredients";
  static const createRecipeSteps = "/create-recipe/steps";
  static const createRecipePreview = "/create-recipe/preview";

  //comment page
  static const commentPage = "/comment-page";
  static const developerPage ="/developer";
  static const bintangDetailPage = "/bintang-detail"; // isi nya tentang kami si bintang
  static const andreDetailPage = "/andre-detail";
  static const claraDetailPage = "/clara-detail";

  //filter kulkas
  static const fridgeFilter = "/fridge-filter";
  static const resultFilter = "/search-result";

  // profile
  static const editProfile = "/edit-profile";
  static const otherProfile = "/other-profile";
  static const fridgeFilterResult = "/fridge-filter-result";
}