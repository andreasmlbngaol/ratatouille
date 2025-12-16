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

  static const recipeDetail = "/main/recipe-detail/:id";

  static const createRecipe = "/create-recipe";
  static const createRecipeBaseInfo = "/create-recipe/base-info";
  static const createRecipeIngredients = "/create-recipe/ingredients";
  static const createRecipeSteps = "/create-recipe/steps";
  static const createRecipePreview = "/create-recipe/preview";
}