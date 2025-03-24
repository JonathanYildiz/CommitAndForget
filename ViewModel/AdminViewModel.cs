using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services;
using CommitAndForget.Services.DataProvider;
using CommitAndForget.View.AdminViews;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Win32;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media.Imaging;

namespace CommitAndForget.ViewModel
{
  public class AdminViewModel : NotifyObject
  {
    #region Properties
    public UserModel CurrentUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    public UserModel SelectedUser
    {
      get => Get<UserModel>();
      set
      {
        if (value != null)
          UserDataProvider.GetUsersFavorites(value);

        Set(value);
        OnPropertyChanged(nameof(IsUserSelected));
      }
    }
    public bool IsUserSelected => SelectedUser != null;

    public ProductModel SelectedProduct
    {
      get => Get<ProductModel>();
      set => Set(value);
    }
    public MenuModel SelectedMenu
    {
      get => Get<MenuModel>();
      set => Set(value);
    }
    public object BackupModel // Um Änderungen rückgängig machen zu können
    {
      get => Get<object>();
      set => Set(value);
    }
    public ImageModel CurrentContestImage
    {
      get => Get<ImageModel>();
      set => Set(value);
    }
    public ObservableCollection<UserModel> UserList
    {
      get => Get<ObservableCollection<UserModel>>();
      set => Set(value);
    }
    public ObservableCollection<MenuModel> MenuList
    {
      get => Get<ObservableCollection<MenuModel>>();
      set => Set(value);
    }
    public ObservableCollection<ProductModel> ProductList
    {
      get => Get<ObservableCollection<ProductModel>>();
      set => Set(value);
    }
    public ObservableCollection<IngredientModel> IngredientList
    {
      get => Get<ObservableCollection<IngredientModel>>();
      set => Set(value);
    }
    public ObservableCollection<ImageModel> ImageList
    {
      get => Get<ObservableCollection<ImageModel>>();
      set => Set(value);
    }
    public ObservableCollection<OrderModel> OrderList
    {
      get => Get<ObservableCollection<OrderModel>>();
      set => Set(value);
    }
    public Frame MainFrame
    {
      get => Get<Frame>();
      set => Set(value);
    }
    public Visibility IsEditUserVisible => Visibility.Collapsed;
    #endregion Properties

    #region Constructor
    public AdminViewModel(UserModel user)
    {
      CurrentUser = user;
      UserList = new ObservableCollection<UserModel>();
      IngredientList = new ObservableCollection<IngredientModel>();
      ImageList = new ObservableCollection<ImageModel>();
      CreateCommands();
    }
    #endregion Constructor

    #region Commands
    private void CreateCommands()
    {
      // Navigation
      NavigateToUserManagementCommand = new RelayCommand(NavigateToUserManagement);
      NavigateToProductManagementCommand = new RelayCommand(NavigateToProductManagement);
      NavigateToOrderManagementCommand = new RelayCommand(NavigateToOrderManagement);
      NavigateToMenuManagementCommand = new RelayCommand(NavigateToMenuManagement);
      NavigateToContestManagementCommand = new RelayCommand(NavigateToContestManagement);
      NavigateBackCommand = new RelayCommand(NavigateBack);
      LogoutCommand = new RelayCommand(Logout);

      // Benutzerverwaltung
      EditUserCommand = new RelayCommand<UserModel>(EditUser);
      DeleteUserCommand = new RelayCommand<UserModel>(DeleteUser);
      SaveUserCommand = new RelayCommand<Window>(SaveUser);
      CancelUserCommand = new RelayCommand<Window>(CancelUser);
      CreateUserCommand = new RelayCommand(CreateUser);

      // Produktverwaltung
      EditProductCommand = new RelayCommand<ProductModel>(EditProduct);
      ToggleIngredientCommand = new RelayCommand<IngredientModel>(ToggleIngredient);
      SaveProductCommand = new RelayCommand(SaveProduct);
      CancelProductCommand = new RelayCommand(CancelProduct);
      DeleteProductCommand = new RelayCommand<ProductModel>(DeleteProduct);
      CreateProductCommand = new RelayCommand(CreateProduct);

      // Menüverwaltung
      CreateMenuCommand = new RelayCommand(CreateMenu);
      EditMenuCommand = new RelayCommand<MenuModel>(EditMenu);
      ToggleProductCommand = new RelayCommand<ProductModel>(ToggleProduct);
      DeleteMenuCommand = new RelayCommand<MenuModel>(DeleteMenu);
      SaveMenuCommand = new RelayCommand(SaveMenu);
      CancelMenuCommand = new RelayCommand(CancelMenu);


      // Bildauswahl und -upload für Produkte und Menüs
      DeleteImageCommand = new RelayCommand<ImageModel>(DeleteImage);
      ChooseImageCommand = new RelayCommand<ImageModel>(ChooseImage);
      SelectImageCommand = new RelayCommand(SelectImage);
      AddImageCommand = new RelayCommand(AddImage);
      RemoveImageFromProductCommand = new RelayCommand(RemoveImageFromProduct);
      RemoveImageFromMenuCommand = new RelayCommand(RemoveImageFromMenu);

      // Contestverwaltung
      NextContestImageCommand = new RelayCommand(NextContestImage);
      PreviousContestImageCommand = new RelayCommand(PreviousContestImage);
      ApproveContestImageCommand = new RelayCommand(ApproveContestImage);
      DeleteContestImageCommand = new RelayCommand(DeleteContestImage);

      // Bestellverwaltung
      DeleteOrderCommand = new RelayCommand<OrderModel>(DeleteOrder);
      ShowOrderDetailsCommand = new RelayCommand<OrderModel>(ShowOrderDetails);
    }
    public ICommand NavigateToUserManagementCommand { get; set; }
    public ICommand NavigateToProductManagementCommand { get; set; }
    public ICommand NavigateToOrderManagementCommand { get; set; }
    public ICommand NavigateToMenuManagementCommand { get; set; }
    public ICommand NavigateToContestManagementCommand { get; set; }
    public ICommand NavigateBackCommand { get; set; }
    public ICommand EditUserCommand { get; set; }
    public ICommand DeleteUserCommand { get; set; }
    public ICommand SaveUserCommand { get; set; }
    public ICommand CancelUserCommand { get; set; }
    public ICommand CreateUserCommand { get; set; }
    public ICommand EditProductCommand { get; set; }
    public ICommand ToggleIngredientCommand { get; set; }
    public ICommand SaveProductCommand { get; set; }
    public ICommand CancelProductCommand { get; set; }
    public ICommand DeleteProductCommand { get; set; }
    public ICommand CreateProductCommand { get; set; }
    public ICommand CreateMenuCommand { get; set; }
    public ICommand EditMenuCommand { get; set; }
    public ICommand ToggleProductCommand { get; set; }
    public ICommand DeleteMenuCommand { get; set; }
    public ICommand SaveMenuCommand { get; set; }
    public ICommand CancelMenuCommand { get; set; }
    public ICommand SelectImageCommand { get; set; }
    public ICommand AddImageCommand { get; set; }
    public ICommand DeleteImageCommand { get; set; }
    public ICommand ChooseImageCommand { get; set; }
    public ICommand RemoveImageFromProductCommand { get; set; }
    public ICommand RemoveImageFromMenuCommand { get; set; }
    public ICommand NextContestImageCommand { get; set; }
    public ICommand PreviousContestImageCommand { get; set; }
    public ICommand ApproveContestImageCommand { get; set; }
    public ICommand DeleteContestImageCommand { get; set; }
    public ICommand LogoutCommand { get; set; }
    public ICommand DeleteOrderCommand { get; set; }
    public ICommand ShowOrderDetailsCommand { get; set; }
    #endregion Commands

    #region Methods

    #region Navigation
    private void NavigateToUserManagement()
    {
      UserList = UserDataProvider.LoadUser();
      MainFrame?.Navigate(new UserManagementView() { DataContext = this });
    }
    private void NavigateToProductManagement()
    {
      SelectedMenu = null; // Null zuweisen um beim Bild auswählen zwischen Menü und Produkt zu unterscheiden
      ProductList = ProductDataProvider.LoadProducts();
      MainFrame?.Navigate(new ProductManagementView() { DataContext = this });
    }
    private void NavigateToOrderManagement()
    {
      OrderList = OrderDataProvider.GetOrderHistory();
      MainFrame?.Navigate(new OrderManagementView() { DataContext = this });
    }
    private void NavigateToMenuManagement()
    {
      SelectedProduct = null; // Null zuweisen um beim Bild auswählen zwischen Menü und Produkt zu unterscheiden
      MenuList = MenuDataProvider.LoadMenus();
      MainFrame?.Navigate(new MenuManagementView() { DataContext = this });
    }
    private void NavigateToContestManagement()
    {
      try
      {
        // Nur unbestätigte Bilder für den Contest laden, die von Usern hochgeladen wurden (Admins laden nur Produktbilder hoch)
        IEnumerable<ImageModel> images = ImageDataProvider.LoadImages().Where(img => img.UploadedBy != "admin" && !img.Approved);
        ImageList = new ObservableCollection<ImageModel>(images);
        CurrentContestImage = ImageList.FirstOrDefault();
        MainFrame?.Navigate(new ContestManagementView() { DataContext = this });
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame?.NavigationService?.GoBack();
    }
    private void CloseCurrentWindow() => Application.Current?.Windows?.OfType<Window>()?.FirstOrDefault(w => w.IsActive)?.Close();

    private void Logout()
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
    #endregion Navigation

    #region User
    private void EditUser(UserModel? user)
    {
      if (user is not null)
      {
        // User wegspeichern falls abgebrochen wird
        BackupModel = new UserModel(user);

        SelectedUser = user;
        var editWindow = new EditUserView() { DataContext = this };
        editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        editWindow.ShowDialog();
      }
    }
    private void DeleteUser(UserModel? user)
    {
      try
      {
        if (user is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie den Benutzer wirklich löschen?", "Benutzer löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            UserDataProvider.DeleteUser(user.Key);
            UserList.Remove(user);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
    private void SaveUser(Window? editWindow)
    {
      if (SelectedUser is not null)
      {
        if (UserList?.Any(UserList => UserList.Key == SelectedUser?.Key) ?? false)
        {
          // Wenn User vorhanden -> Updaten
          UserDataProvider.UpdateUser(SelectedUser);
        }
        else
        {
          // Wenn nicht vorhanden -> Erstellen
          if (string.IsNullOrWhiteSpace(SelectedUser.Email) || string.IsNullOrWhiteSpace(SelectedUser.Password))
          {
            MessageBoxService.DisplayMessage("Email und Passwort müssen angegeben werden", MessageBoxImage.Information);
            return;
          }
          var addedUser = UserDataProvider.Register(SelectedUser);
          if (addedUser is not null)
            UserList?.Add(addedUser);
          else
            return;
        }
      }
      SelectedUser = null;
      editWindow?.Close();
    }
    private void CancelUser(Window? editWindow)
    {
      try
      {
        if (BackupModel is not null && BackupModel is UserModel userBackup)
          SelectedUser.RollbackChanges(userBackup);

        SelectedUser = null;
        BackupModel = null;
        editWindow?.Close();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void CreateUser()
    {
      try
      {
        SelectedUser = new UserModel();
        var editWindow = new EditUserView() { DataContext = this };
        editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        editWindow.ShowDialog();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
    #endregion User

    #region Product
    private void EditProduct(ProductModel? product)
    {
      try
      {
        if (product is not null)
        {
          // Produkut wegspeichern falls abgebrochen wird
          BackupModel = new ProductModel(product);

          IngredientList = IngredientDataProvider.LoadIngredients(product.Key);
          SelectedProduct = product;

          foreach (var ingredient in IngredientList) //Checkboxes initialisieren
          {
            if (product.Ingredients.FirstOrDefault(i => i.Key == ingredient.Key) != null)
              ingredient.IsChecked = true;
          }

          var editWindow = new EditProductView() { DataContext = this };
          editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
          editWindow.ShowDialog();
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ToggleIngredient(IngredientModel? ingredient)
    {
      try
      {
        if (ingredient is not null)
        {
          var foundIngredient = SelectedProduct.Ingredients.FirstOrDefault(i => i.Key == ingredient.Key);

          if (foundIngredient != null)
            SelectedProduct.Ingredients.Remove(foundIngredient); // Entfernen
          else
            SelectedProduct.Ingredients.Add(ingredient); // Hinzufügen
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void SaveProduct()
    {
      try
      {
        if (SelectedProduct is not null)
        {
          // Eingaben überprüfen
          if (string.IsNullOrEmpty(SelectedProduct.Name))
          {
            MessageBoxService.DisplayMessage("Name darf nicht leer sein", MessageBoxImage.Information);
            return;
          }
          else if (SelectedProduct.Price == 0)
          {
            MessageBoxService.DisplayMessage("Preis darf nicht 0 sein", MessageBoxImage.Information);
            return;
          }
          else if (SelectedProduct.Ingredients?.Count == 0)
          {
            MessageBoxService.DisplayMessage("Es muss mindestens eine Zutat zugewiesen werden", MessageBoxImage.Information);
            return;
          }

          if (ProductList.Any(p => p.Key == SelectedProduct.Key)) // Wenn Produkt vorhanden -> Updaten
          {
            ProductDataProvider.UpdateProduct(SelectedProduct);
            ProductDataProvider.DeleteProductsIngredients(SelectedProduct.Key); // Alle Zutaten löschen
            foreach (var ingredient in SelectedProduct.Ingredients)
            {
              var foundIngredient = IngredientList.FirstOrDefault(i => i.Key == ingredient.Key);
              if (foundIngredient is null)
                continue;

              ProductDataProvider.AddProductIngredient(SelectedProduct.Key, ingredient.Key, foundIngredient.Quantity); // Zutaten hinzufügen
            }
          }
          else
          {
            SelectedProduct.Key = ProductDataProvider.CreateProduct(SelectedProduct); // Wenn nicht vorhanden -> Erstellen
            if (SelectedProduct.Key > 0)
            {
              foreach (var ingredient in SelectedProduct.Ingredients)
                ProductDataProvider.AddProductIngredient(SelectedProduct.Key, ingredient.Key, ingredient.Quantity);

              ProductList.Add(new ProductModel(SelectedProduct));
            }
            else
              return;
          }
        }
        SelectedProduct = null;
        BackupModel = null;
        CloseCurrentWindow();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void CancelProduct()
    {
      try
      {
        if (BackupModel is not null && BackupModel is ProductModel productBackup)
          SelectedProduct.RollbackChanges(productBackup);

        SelectedProduct = null;
        BackupModel = null;
        CloseCurrentWindow();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void DeleteProduct(ProductModel? prodct)
    {
      try
      {
        if (prodct is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie das Produkt wirklich löschen?", "Produkt löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            ProductDataProvider.DeleteProduct(prodct.Key);
            ProductList?.Remove(prodct);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public void CreateProduct()
    {
      try
      {
        IngredientList = IngredientDataProvider.LoadIngredients(-1); // Alle Zutaten laden
        SelectedProduct = new ProductModel();
        var editWindow = new EditProductView() { DataContext = this };
        editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        editWindow.ShowDialog();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
    #endregion Product

    #region Menu
    public void CreateMenu()
    {
      try
      {
        ProductList = ProductDataProvider.LoadProducts(); // Alle Produkte laden
        SelectedMenu = new MenuModel();
        var editWindow = new EditMenuView() { DataContext = this };
        editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        editWindow.ShowDialog();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void SaveMenu()
    {
      try
      {
        if (SelectedMenu is not null)
        {
          // Eingaben überprüfen
          if (string.IsNullOrEmpty(SelectedMenu.Name))
          {
            MessageBoxService.DisplayMessage("Name darf nicht leer sein", MessageBoxImage.Information);
            return;
          }
          else if (SelectedMenu.Price == 0)
          {
            MessageBoxService.DisplayMessage("Preis darf nicht 0 sein", MessageBoxImage.Information);
            return;
          }
          else if (SelectedMenu.ProductList?.Count == 0)
          {
            MessageBoxService.DisplayMessage("Es muss mindestens ein Produkt zugewiesen werden", MessageBoxImage.Information);
            return;
          }

          if (MenuList.Any(p => p.Key == SelectedMenu.Key)) // Wenn Produkt vorhanden -> Updaten
          {
            MenuDataProvider.UpdateMenu(SelectedMenu);
            MenuDataProvider.DeleteMenuProduct(SelectedMenu.Key); // Alle Produkte zum Menü löschen
            foreach (var product in SelectedMenu.ProductList)
            {
              var foundProduct = ProductList.FirstOrDefault(p => p.Key == product.Key);
              if (foundProduct is null)
                continue;

              MenuDataProvider.AddMenuProduct(SelectedMenu.Key, product.Key, foundProduct.Quantity); // Produkt hinzufügen
            }
          }
          else
          {
            SelectedMenu.Key = MenuDataProvider.CreateMenu(SelectedMenu); // Wenn nicht vorhanden -> Erstellen
            if (SelectedMenu.Key > 0)
            {
              foreach (var product in SelectedMenu.ProductList)
                MenuDataProvider.AddMenuProduct(SelectedMenu.Key, product.Key, product.Quantity);

              MenuList.Add(new MenuModel(SelectedMenu));
            }
            else
              return;
          }
        }
        SelectedMenu = null;
        BackupModel = null;
        CloseCurrentWindow();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ToggleProduct(ProductModel? product)
    {
      try
      {
        if (product is not null)
        {
          var foundProduct = SelectedMenu?.ProductList?.FirstOrDefault(i => i.Key == product.Key);

          if (foundProduct != null)
            SelectedMenu?.ProductList?.Remove(foundProduct); // Entfernen
          else
            SelectedMenu?.ProductList?.Add(product); // Hinzufügen
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void DeleteMenu(MenuModel? menu)
    {
      try
      {
        if (menu is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie das Menü wirklich löschen?", "Produkt löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            MenuDataProvider.DeleteMenu(menu.Key);
            MenuList?.Remove(menu);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void EditMenu(MenuModel? menu)
    {
      try
      {
        if (menu is not null)
        {
          // Menü wegspeichern falls abgebrochen wird
          BackupModel = new MenuModel(menu);

          ProductList = ProductDataProvider.LoadProducts();
          SelectedMenu = menu;

          foreach (var product in ProductList) //Checkboxes initialisieren
          {
            var foundProduct = menu.ProductList.FirstOrDefault(p => p.Key == product.Key);
            if (foundProduct != null)
            {
              product.IsChecked = true;
              product.Quantity = foundProduct.Quantity;
            }
            else
            {
              product.IsChecked = false;
              product.Quantity = 0;
            }
          }

          var editWindow = new EditMenuView() { DataContext = this };
          editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
          editWindow.ShowDialog();
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void CancelMenu()
    {
      try
      {
        if (BackupModel is not null && BackupModel is MenuModel menuBackup)
          SelectedMenu.RollbackChanges(menuBackup);

        SelectedMenu = null;
        BackupModel = null;
        CloseCurrentWindow();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
    #endregion Menu

    #region Image
    private void SelectImage()
    {
      ImageList = ImageDataProvider.LoadImages();
      var window = new ShowImagesView() { DataContext = this };
      window.WindowStartupLocation = WindowStartupLocation.CenterScreen;
      window.ShowDialog();
    }

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
          ImageList?.Add(image);
      }
    }
    private void DeleteImage(ImageModel? image)
    {
      try
      {
        if (image is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie das Bild wirklich löschen?", "Bild löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            ImageDataProvider.DeleteImage(image.Key);
            ImageList.Remove(image);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ChooseImage(ImageModel? image)
    {
      try
      {
        if (image is null)
          return;

        if (SelectedProduct is not null)
        {
          SelectedProduct.Image = image;
          CloseCurrentWindow();
        }
        else if (SelectedMenu is not null)
        {
          SelectedMenu.Image = image;
          CloseCurrentWindow();
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void RemoveImageFromProduct()
    {
      if (SelectedProduct != null && SelectedProduct.Image != null)
      {
        SelectedProduct.Image.Image = null;
        SelectedProduct.Image.Key = 0;
      }
    }

    private void RemoveImageFromMenu()
    {
      if (SelectedMenu != null && SelectedMenu.Image != null)
      {
        SelectedMenu.Image.Image = null;
        SelectedMenu.Image.Key = 0;
      }
    }
    #endregion Image

    #region Contest
    private void NextContestImage()
    {
      try
      {
        if (CurrentContestImage is not null && ImageList is not null)
        {
          var index = ImageList.IndexOf(CurrentContestImage);
          if (index < ImageList.Count - 1) // Nächstes Bild
            CurrentContestImage = ImageList[index + 1];
          else if (index == ImageList.Count - 1) // Am Ende -> Erstes Bild
            CurrentContestImage = ImageList[0];
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void PreviousContestImage()
    {
      try
      {
        if (CurrentContestImage is not null && ImageList is not null)
        {
          var index = ImageList.IndexOf(CurrentContestImage);
          if (index > 0) // Vorheriges Bild
            CurrentContestImage = ImageList[index - 1];
          else if (index == 0) // Am Anfang -> Letztes Bild
            CurrentContestImage = ImageList[ImageList.Count - 1];
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ApproveContestImage()
    {
      try
      {
        if (CurrentContestImage is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie das Bild freigeben?", "Bild freigeben", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            ImageDataProvider.ApproveImage(CurrentContestImage);
            ImageList.Remove(CurrentContestImage);
            if (ImageList.Count > 0)
              NextContestImage();
            else
              CurrentContestImage = null;
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void DeleteContestImage()
    {
      try
      {
        if (CurrentContestImage is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie das Bild wirklich löschen?", "Bild löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            ImageDataProvider.DeleteImage(CurrentContestImage.Key);
            ImageList.Remove(CurrentContestImage);
            CurrentContestImage = ImageList?.FirstOrDefault();
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    #endregion Contest

    #region Order

    private void DeleteOrder(OrderModel? order)
    {
      try
      {
        if (order is not null)
        {
          var msgBox = MessageBox.Show("Möchten Sie die Bestellung wirklich löschen?", "Bestellung löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
          if (msgBox == MessageBoxResult.Yes)
          {
            if (OrderDataProvider.DeleteOrder(order.Key))
              OrderList?.Remove(order);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ShowOrderDetails(OrderModel? order)
    {
      try
      {
        if (order is not null)
        {
          string orderDetails = OrderDataProvider.GetOrderDetails(order.Key);
          if (!string.IsNullOrEmpty(orderDetails))
          {
            orderDetails += $"\nGesamtpreis: {order.TotalPrice}";
            MessageBoxService.DisplayMessage(orderDetails, MessageBoxImage.Information);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    #endregion Order

    #endregion Methods
  }
}
