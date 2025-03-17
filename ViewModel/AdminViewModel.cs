using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media.Imaging;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services;
using CommitAndForget.Services.DataProvider;
using CommitAndForget.View.AdminViews;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Win32;

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
      set => Set(value);
    }
    public ProductModel SelectedProduct
    {
      get => Get<ProductModel>();
      set => Set(value);
    }
    public ProductModel ProductBackup
    {
      get => Get<ProductModel>();
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
    public Frame MainFrame
    {
      get => Get<Frame>();
      set => Set(value);
    }
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
      NavigateToUserManagementCommand = new RelayCommand(NavigateToUserManagement);
      NavigateToProductManagementCommand = new RelayCommand(NavigateToProductManagement);
      NavigateToOrderManagementCommand = new RelayCommand(NavigateToOrderManagement);
      NavigateToMenuManagementCommand = new RelayCommand(NavigateToMenuManagement);
      NavigateToContestManagementCommand = new RelayCommand(NavigateToImageManagement);
      NavigateBackCommand = new RelayCommand(NavigateBack);
      EditUserCommand = new RelayCommand<UserModel>(EditUser);
      DeleteUserCommand = new RelayCommand<UserModel>(DeleteUser);
      SaveUserCommand = new RelayCommand<Window>(SaveUser);
      CancelUserCommand = new RelayCommand<Window>(CancelUser);
      CreateUserCommand = new RelayCommand(CreateUser);
      EditProductCommand = new RelayCommand<ProductModel>(EditProduct);
      ToggleIngredientCommand = new RelayCommand<IngredientModel>(ToggleIngredient);
      SaveProductCommand = new RelayCommand(SaveProduct);
      CancelProductCommand = new RelayCommand(CancelProduct);
      DeleteProductCommand = new RelayCommand<ProductModel>(DeleteProduct);
      CreateProductCommand = new RelayCommand(CreateProduct);
      SelectImageCommand = new RelayCommand(SelectImage);
      AddImageCommand = new RelayCommand(AddImage);
      DeleteImageCommand = new RelayCommand<ImageModel>(DeleteImage);
      ChooseImageCommand = new RelayCommand<ImageModel>(ChooseImage);
      RemoveImageFromProductCommand = new RelayCommand(RemoveImageFromProduct);    
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
    public ICommand SelectImageCommand { get; set; }
    public ICommand AddImageCommand { get; set; }
    public ICommand DeleteImageCommand { get; set; }
    public ICommand ChooseImageCommand { get; set; }
    public ICommand RemoveImageFromProductCommand { get; set; }
    public ICommand NextImageCommand { get; set; }
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
      ProductList = ProductDataProvider.LoadProducts();
      MainFrame?.Navigate(new ProductManagementView() { DataContext = this });
    }
    private void NavigateToOrderManagement() => MainFrame?.Navigate(new OrderManagementView() { DataContext = this });
    private void NavigateToMenuManagement() => MainFrame?.Navigate(new MenuManagementView() { DataContext = this });
    private void NavigateToImageManagement() 
    {
      ImageList = ImageDataProvider.LoadImages(); 
      MainFrame?.Navigate(new ContestManagementView() { DataContext = this });
    }
    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame.NavigationService.GoBack();
    }
    private void CloseCurrentWindow() => Application.Current.Windows.OfType<Window>().SingleOrDefault(w => w.IsActive)?.Close();
    #endregion Navigation

    #region User
    private void EditUser(UserModel? user)
    {
      if (user is not null)
      {
        SelectedUser = user;
        var editWindow = new EditUserView() { DataContext = this };
        editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        editWindow.ShowDialog();
      }
    }
    private void DeleteUser(UserModel? user)
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
    private void SaveUser(Window? editWindow)
    {
      if (SelectedUser is not null)
      {
        if (UserList.Any(UserList => UserList.Key == SelectedUser.Key)) // Wenn User vorhanden -> Updaten
        {
          UserDataProvider.UpdateUser(SelectedUser);
        }
        else
        {
          var addedUser = UserDataProvider.Register(SelectedUser); // Wenn nicht vorhanden -> Erstellen
          if (addedUser is not null)
            UserList.Add(addedUser);
          else
            return;
        }
      }
      SelectedUser = null;
      editWindow?.Close();
    }
    private void CancelUser(Window? editWindow)
    {
      SelectedUser = null;
      editWindow?.Close();
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
      if (product is not null)
      {
        // Produkut wegspeichern falls abgebrochen wird
        ProductBackup = new ProductModel(product);

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
    private void ToggleIngredient(IngredientModel? ingredient)
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
    private void SaveProduct()
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
      ProductBackup = null;
      CloseCurrentWindow();
    }
    private void CancelProduct()
    {
      if (ProductBackup is not null)
        SelectedProduct = new ProductModel(ProductBackup);

      SelectedProduct = null;
      ProductBackup = null;
      CloseCurrentWindow();
    }
    private void DeleteProduct(ProductModel? prodct)
    {
      if (prodct is not null)
      {
        var msgBox = MessageBox.Show("Möchten Sie das Produkt wirklich löschen?", "Produkt löschen", MessageBoxButton.YesNo, MessageBoxImage.Question);
        if (msgBox == MessageBoxResult.Yes)
        {
          ProductDataProvider.DeleteProduct(prodct.Key);
          ProductList.Remove(prodct);
        }
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
        image = ImageDataProvider.UploadImage(image);
        if (image is not null)
          ImageList.Add(image);
      }
    }
    private void DeleteImage(ImageModel? image)
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
    private void ChooseImage(ImageModel? image)
    {
      if (image is not null && SelectedProduct is not null)
      {
        SelectedProduct.Image = image;
        CloseCurrentWindow();
      }
    }
    private void RemoveImageFromProduct()
    {
      SelectedProduct.Image.Image = null;
      SelectedProduct.Image.Key = 0;
    }
    #endregion Image
    
    #endregion Methods
  }
}
