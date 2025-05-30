﻿using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services;
using CommitAndForget.Services.DataProvider;
using CommitAndForget.View.UserViews;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Win32;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using System.Windows.Media.Imaging;

namespace CommitAndForget.ViewModel
{
  public class UserViewModel : NotifyObject
  {
    #region Properties
    public UserModel CurrentUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    public UserModel BackupUser // Um Änderungen am User rückgängig machen zu können
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    public ObservableCollection<ProductModel> ProductList
    {
      get => Get<ObservableCollection<ProductModel>>();
      set => Set(value);
    }
    public ICollectionView FilteredProductList
    {
      get => Get<ICollectionView>();
      set => Set(value);
    }
    public ObservableCollection<MenuModel> MenuList
    {
      get => Get<ObservableCollection<MenuModel>>();
      set => Set(value);
    }
    public ICollectionView FilteredMenuList
    {
      get => Get<ICollectionView>();
      set => Set(value);
    }
    public ObservableCollection<IngredientModel> IngredientList
    {
      get => Get<ObservableCollection<IngredientModel>>();
      set => Set(value);
    }
    public ObservableCollection<ProductModel> ProductShoppingCart
    {
      get => Get<ObservableCollection<ProductModel>>();
      set => Set(value);
    }
    public ObservableCollection<MenuModel> MenuShoppingCart
    {
      get => Get<ObservableCollection<MenuModel>>();
      set => Set(value);
    }
    public ObservableCollection<ImageModel> ImageList
    {
      get => Get<ObservableCollection<ImageModel>>();
      set => Set(value);
    }
    public ObservableCollection<ImageModel> ContestWinner
    {
      get => Get<ObservableCollection<ImageModel>>();
      set => Set(value);
    }
    public IngredientModel SelectedIngredient
    {
      get => Get<IngredientModel>();
      set
      {
        Set(value);
        FilteredProductList?.Refresh();
        FilteredMenuList?.Refresh();
      }
    }
    // Anzahl der Produkte und Menüs im Warenkorb zusammenrechnen
    public int ShoppingCartQuantity => (ProductShoppingCart?.Sum(item => item.Quantity) ?? 0) + (MenuShoppingCart?.Sum(item => item.Quantity) ?? 0);

    public bool ShowShoppingCart
    {
      get => Get<bool>();
      set
      {
        OnPropertyChanged(nameof(ShoppingCartPrice));
        Set(value);
      }
    }

    // Gesamtpreis der Warenkörbe ermitteln
    public double ShoppingCartPrice => Math.Round((ProductShoppingCart?.Sum(item => item.Quantity * item.Price) ?? 0) + (MenuShoppingCart?.Sum(item => item.Quantity * item.Price) ?? 0), 2);

    public Frame MainFrame
    {
      get => Get<Frame>();
      set => Set(value);
    }
    public Visibility IsEditUserVisible => Visibility.Visible;
    #endregion Properties

    #region Constructor
    public UserViewModel(UserModel user)
    {
      CurrentUser = user;
      ProductList = new ObservableCollection<ProductModel>();
      MenuList = new ObservableCollection<MenuModel>();
      ProductShoppingCart = new ObservableCollection<ProductModel>();
      MenuShoppingCart = new ObservableCollection<MenuModel>();
      CreateCommands();
    }
    #endregion Constructor

    #region Commands
    private void CreateCommands()
    {
      // Navigation
      NavigateToUserOrderCommand = new RelayCommand(NavigateToUserOrder);
      NavigateBackCommand = new RelayCommand(NavigateBack);
      NavigateToMenuCommand = new RelayCommand(NavigateToMenu);
      NavigateToProductCommand = new RelayCommand(NavigateToProduct);
      NavigateToFunnyDinnerContestCommand = new RelayCommand(NavigateToFunnyDinnerContest);

      // Bestellung
      ToggleShowShoppingCartCommand = new RelayCommand(ToggleShowShoppingCart);
      AddProductToShoppingCartCommand = new RelayCommand<ProductModel>(AddProductToShoppingCart);
      AddMenuToShoppingCartCommand = new RelayCommand<MenuModel>(AddMenuToShoppingCart);
      ShowProductInfoCommand = new RelayCommand<ProductModel>(ShowProductInfo);
      ShowMenuInfoCommand = new RelayCommand<MenuModel>(ShowMenuInfo);
      RemoveProductFromShoppingCartCommand = new RelayCommand<ProductModel>(RemoveProductFromShoppingCart);
      RemoveMenuFromShoppingCartCommand = new RelayCommand<MenuModel>(RemoveMenuFromShoppingCart);
      NavigateToPaymentCommand = new RelayCommand(NavigateToPayment);
      PayCommand = new RelayCommand<string>(Pay);

      // FunnyDinnerContest
      AddImageCommand = new RelayCommand(AddImage);
      RateImageCommand = new RelayCommand<Tuple<ImageModel, decimal>>(RateImage);
      ViewWinnerCommand = new RelayCommand(ViewWinner);

      // Benutzer
      EditProfileCommand = new RelayCommand(EditProfile);
      CancelEditCommand = new RelayCommand<Window>(CancelEdit);
      SaveEditCommand = new RelayCommand<Window>(SaveEdit);
      LogoutCommand = new RelayCommand(LogoutUser);
    }
    public ICommand NavigateToUserOrderCommand { get; set; }
    public ICommand NavigateBackCommand { get; set; }
    public ICommand NavigateToMenuCommand { get; set; }
    public ICommand NavigateToProductCommand { get; set; }
    public ICommand NavigateToFunnyDinnerContestCommand { get; set; }
    public ICommand ToggleShowShoppingCartCommand { get; set; }
    public ICommand AddProductToShoppingCartCommand { get; set; }
    public ICommand AddMenuToShoppingCartCommand { get; set; }
    public ICommand ShowProductInfoCommand { get; set; }
    public ICommand ShowMenuInfoCommand { get; set; }
    public ICommand RemoveProductFromShoppingCartCommand { get; set; }
    public ICommand RemoveMenuFromShoppingCartCommand { get; set; }
    public ICommand NavigateToPaymentCommand { get; set; }
    public ICommand PayCommand { get; set; }
    public ICommand AddImageCommand { get; set; }
    public ICommand RateImageCommand { get; set; }
    public ICommand ViewWinnerCommand { get; set; }
    public ICommand LogoutCommand { get; set; }
    public ICommand EditProfileCommand { get; set; }
    public ICommand CancelEditCommand { get; set; }
    public ICommand SaveEditCommand { get; set; }
    #endregion Commands

    #region Methods
    #region Navigation
    // Methoden zur Navigation (DataContext ist das zentrale UserViewModel)
    private void NavigateToUserOrder() => MainFrame?.Navigate(new OrderView() { DataContext = this });
    private void NavigateToMenu()
    {
      MenuList = MenuDataProvider.LoadMenus();
      ShowShoppingCart = false; // Wenn mit aktivem Warenkob zurück und wieder vor navigiert wird, soll dieser wieder ausgeblendet sein

      // Zutaten aus den Menüs Laden um Filter im Frontend anzeigen zu können
      IngredientList = new ObservableCollection<IngredientModel>();
      foreach (var menu in MenuList)
      {
        foreach (var product in menu.ProductList)
        {
          var ingredients = IngredientDataProvider.LoadIngredients(product.Key);
          foreach (var ingredient in ingredients)
          {
            if (IngredientList.FirstOrDefault(i => i.Name == ingredient.Name) == null) // Nicht doppelt hinzufügen
              IngredientList.Add(ingredient);

            product.Ingredients.Add(ingredient);
          }
        }
      }

      FilteredMenuList = CollectionViewSource.GetDefaultView(MenuList);
      FilteredMenuList.Filter = FilterMenus;
      MainFrame?.Navigate(new MenuView() { DataContext = this });
    }
    private void NavigateToProduct()
    {
      ProductList = ProductDataProvider.LoadProducts();
      ShowShoppingCart = false; // Wenn mit aktivem Warenkob zurück und wieder vor navigiert wird, soll dieser wieder ausgeblendet sein

      // Zutaten aus den Produkten Laden um Filter im Frontend anzeigen zu können
      IngredientList = new ObservableCollection<IngredientModel>();
      foreach (var product in ProductList)
      {
        foreach (var ingredient in product.Ingredients)
        {
          if (IngredientList.FirstOrDefault(i => i.Name == ingredient.Name) == null) // Nicht doppelt hinzufügen
            IngredientList.Add(ingredient);
        }
      }

      FilteredProductList = CollectionViewSource.GetDefaultView(ProductList);
      FilteredProductList.Filter = FilterProducts;
      MainFrame?.Navigate(new ProductView() { DataContext = this });
    }

    private void NavigateToFunnyDinnerContest()
    {
      // Keine Produktbilder laden
      IEnumerable<ImageModel> images = ImageDataProvider.LoadImages(CurrentUser.Key).Where(img => img.UploadedBy != "admin" && img.Approved);
      ImageList = new ObservableCollection<ImageModel>(images);
      MainFrame?.Navigate(new FunnyDinnerContestView() { DataContext = this });
    }

    private void ToggleShowShoppingCart() => ShowShoppingCart = !ShowShoppingCart;

    private void NavigateToPayment()
    {
      if (ShoppingCartQuantity > 0)
        MainFrame?.Navigate(new PaymentView() { DataContext = this });
    }

    private void Pay(string? paymentMethod)
    {
      // Abfangen, wenn die Warenkörbe leer sind
      if (MenuShoppingCart is null || MenuShoppingCart.Count == 0)
        if (ProductShoppingCart is null || ProductShoppingCart.Count == 0)
          return;

      if (paymentMethod is not null)
      {
        int orderNumber = OrderDataProvider.CreateOrder(CurrentUser.Key, paymentMethod);
        if (orderNumber == -1)
        {
          MessageBoxService.DisplayMessage("Fehler beim Erstellen der Bestellung", MessageBoxImage.Error);
          return;
        }

        OrderDataProvider.AddProductsToOrder(ProductShoppingCart, orderNumber);
        OrderDataProvider.AddMenusToOrder(MenuShoppingCart, orderNumber);

        MenuShoppingCart?.Clear();
        ProductShoppingCart?.Clear();
        OnPropertyChanged(nameof(ShoppingCartQuantity));
        MessageBoxService.DisplayMessage($"Vielen Dank für Ihre Bestellung\nZahlungsart: {paymentMethod}", MessageBoxImage.Information);
        MainFrame?.Navigate(new UserSelectionView { DataContext = this });
      }
    }

    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame.NavigationService.GoBack();
    }

    #endregion Navigation

    #region IngredientFilter
    private bool FilterProducts(object obj)
    {
      if (obj is ProductModel product)
      {
        if (SelectedIngredient is null)
          return true;
        else
          return product.Ingredients.FirstOrDefault(x => x.Key == SelectedIngredient.Key && x.Quantity > 0) != null;
      }

      return false;
    }

    private bool FilterMenus(object obj)
    {
      if (obj is MenuModel menu)
      {
        if (SelectedIngredient is null)
          return true;
        else
        {
          foreach (var product in menu.ProductList)
          {
            if (product.Ingredients.FirstOrDefault(x => x.Key == SelectedIngredient.Key && x.Quantity > 0) != null)
              return true;
          }
        }
      }
      return false;
    }
    #endregion IngredientFilter

    #region Order
    private void AddProductToShoppingCart(ProductModel? product)
    {
      if (product is not null)
      {
        // Wenn Produkt bereits in Warenkorb => Menge erhöhen
        var productInList = ProductShoppingCart.FirstOrDefault(p => p.Key == product.Key);
        if (productInList is null)
          ProductShoppingCart.Add(product);
        else
          productInList.Quantity++;

        OnPropertyChanged(nameof(ShoppingCartQuantity));
        OnPropertyChanged(nameof(ShoppingCartPrice));
      }
    }

    private void AddMenuToShoppingCart(MenuModel? menu)
    {
      if (menu is not null)
      {
        // Wenn Menü bereits in Warenkorb => Menge erhöhen
        var menuInList = MenuShoppingCart.FirstOrDefault(m => m.Key == menu.Key);
        if (menuInList is null)
          MenuShoppingCart.Add(menu);
        else
          menuInList.Quantity++;

        OnPropertyChanged(nameof(ShoppingCartQuantity));
        OnPropertyChanged(nameof(ShoppingCartPrice));
      }
    }

    private void ShowProductInfo(ProductModel? product)
    {
      if (product is not null)
      {
        string ingredients = "";
        foreach (var ingredient in product.Ingredients)
          ingredients += ingredient.Name + "\n";

        MessageBoxService.DisplayMessage($"Produkt: {product.Name} ({product.Energy}kcal)\n\nZutaten:\n{ingredients}", MessageBoxImage.Information);
      }
    }

    private void ShowMenuInfo(MenuModel? menu)
    {
      if (menu is not null)
      {
        string products = "";
        foreach (var product in menu.ProductList)
        {
          string ingredients = "";
          foreach (var ingredient in product.Ingredients)
            if (ingredient.Quantity > 0)
              ingredients += ingredient.Name + "\n";
          products += $"Produkt: {product.Name} ({product.Energy}kcal)\nZutaten:\n{ingredients}\n\n";
        }
        MessageBoxService.DisplayMessage($"Menü: {menu.Name}\n\n{products}", MessageBoxImage.Information);
      }
    }

    private void RemoveProductFromShoppingCart(ProductModel? product)
    {
      if (product is not null)
      {
        ProductShoppingCart?.Remove(product);
        product.Quantity = 1;
        OnPropertyChanged(nameof(ShoppingCartQuantity));
        OnPropertyChanged(nameof(ShoppingCartPrice));
      }
    }

    private void RemoveMenuFromShoppingCart(MenuModel? menu)
    {
      if (menu is not null)
      {
        MenuShoppingCart?.Remove(menu);
        menu.Quantity = 1;
        OnPropertyChanged(nameof(ShoppingCartQuantity));
        OnPropertyChanged(nameof(ShoppingCartPrice));
      }
    }
    #endregion Order

    #region FunnyDinnerContest
    private void AddImage()
    {
      var image = new ImageModel();
      var dialog = new OpenFileDialog();
      dialog.Filter = "Bild-Dateien (*.jpg, *.jpeg, *.png)|*.jpg;*.jpeg;*.png";
      if (dialog.ShowDialog() == true)
      {
        image.Image = new BitmapImage(new Uri(dialog.FileName));
        image = ImageDataProvider.UploadImage(image, CurrentUser.Key);
        if (image is not null)
          ImageList.Add(image);
      }
    }

    private void RateImage(Tuple<ImageModel, decimal>? parameter)
    {
      try
      {
        if (parameter is null)
          return;

        ImageModel selectedImage = parameter.Item1;
        decimal rating = parameter.Item2;

        if (selectedImage != null && rating > 0)
        {
          selectedImage.Rating = rating;
          ImageDataProvider.SetRating(selectedImage, CurrentUser.Key);
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ViewWinner()
    {
      ContestWinner = ImageDataProvider.GetLastWinners();

      // Prüfen, ob Gewinner ermittelt werden konnte
      if (ContestWinner is null)
      {
        MessageBoxService.DisplayMessage("Gewinner des letzten Monats konnte nicht ermittelt werden", MessageBoxImage.Error);
        return;
      }

      var winnerWindow = new ContestWinnerView { DataContext = this };
      winnerWindow.Owner = Application.Current.Windows.OfType<Window>().FirstOrDefault(w => w.IsActive);
      winnerWindow.WindowStartupLocation = WindowStartupLocation.CenterOwner;
      winnerWindow?.Show();
    }
    #endregion FunnyDinnerContest

    #region User
    private void EditProfile()
    {
      try
      {
        BackupUser = new UserModel(CurrentUser);

        var view = new ProfileEditView();
        view.DataContext = this;
        view.Owner = Application.Current.Windows.OfType<Window>().FirstOrDefault(w => w.IsActive);
        view.WindowStartupLocation = WindowStartupLocation.CenterOwner;
        view.ShowDialog();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void CancelEdit(Window? window)
    {
      try
      {
        CurrentUser.RollbackChanges(BackupUser);
        window?.Close();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void SaveEdit(Window? window)
    {
      if (CurrentUser is not null)
      {
        UserDataProvider.UpdateUser(CurrentUser);
        BackupUser = null;
        window?.Close();
      }
    }
    private void LogoutUser()
    {
      if (MessageBoxService.LogoutMessage("Möchten Sie sich wirklich abmelden?", MessageBoxImage.Information) == MessageBoxResult.Yes)
      {
        // Aktuelles Window wegspeichern
        var currentWindow = Application.Current?.Windows?.OfType<Window>()?.FirstOrDefault(w => w.IsActive);

        var view = new LoginView();
        view.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        view.DataContext = new LoginViewModel();
        view.Show();

        // Altes Fenster schließen
        currentWindow?.Close();
      }
    }
    #endregion User

    #endregion Methods
  }
}
