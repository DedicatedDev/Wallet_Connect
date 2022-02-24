enum AppRouter {
  main,
}

extension RouterInfo on AppRouter {
  String namespace() {
    switch (this) {
      case AppRouter.main:
        return '/';
   
      default:
        return "/";
    }
  }
}
