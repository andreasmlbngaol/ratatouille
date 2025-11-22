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

  // Search pages
  static const searchRecipe = '/search-recipe';
  static const searchUser = '/search-user';

  static const recipeDetail = "main/recipe-detail/:id";
  static const createRecipe = "main/create-recipe";
}