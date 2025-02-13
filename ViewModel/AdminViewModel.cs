using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media.Imaging;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
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
      NavigateToImageManagementCommand = new RelayCommand(NavigateToImageManagement);
      NavigateBackCommand = new RelayCommand(NavigateBack);
      EditUserCommand = new RelayCommand<UserModel>(EditUser);
      DeleteUserCommand = new RelayCommand<UserModel>(DeleteUser);
      SaveUserCommand = new RelayCommand<Window>(SaveUser);
      CancelUserCommand = new RelayCommand<Window>(CancelUser);
      CreateUserCommand = new RelayCommand(CreateUser);
      EditProductCommand = new RelayCommand<ProductModel>(EditProduct);
      ToggleIngredientCommand = new RelayCommand<IngredientModel>(ToggleIngredient);
      SaveProductCommand = new RelayCommand(SaveProduct);
      DeleteProductCommand = new RelayCommand<ProductModel>(DeleteProduct);
      SelectImageCommand = new RelayCommand(SelectImage);
      AddImageCommand = new RelayCommand(AddImage);
      DeleteImageCommand = new RelayCommand<ImageModel>(DeleteImage);
      ChooseImageCommand = new RelayCommand<ImageModel>(ChooseImage);
      RemoveImageFromProductCommand = new RelayCommand(RemoveImageFromProduct);
    }
    public ICommand NavigateToUserManagementCommand { get; private set; }
    public ICommand NavigateToProductManagementCommand { get; private set; }
    public ICommand NavigateToOrderManagementCommand { get; private set; }
    public ICommand NavigateToMenuManagementCommand { get; private set; }
    public ICommand NavigateToImageManagementCommand { get; private set; }
    public ICommand NavigateBackCommand { get; private set; }
    public ICommand EditUserCommand { get; private set; }
    public ICommand DeleteUserCommand { get; private set; }
    public ICommand SaveUserCommand { get; private set; }
    public ICommand CancelUserCommand { get; private set; }
    public ICommand CreateUserCommand { get; private set; }
    public ICommand EditProductCommand { get; private set; }
    public ICommand ToggleIngredientCommand { get; private set; }
    public ICommand SaveProductCommand { get; private set; }
    public ICommand DeleteProductCommand { get; private set; }
    public ICommand SelectImageCommand { get; private set; }
    public ICommand AddImageCommand { get; private set; }
    public ICommand DeleteImageCommand { get; private set; }
    public ICommand ChooseImageCommand { get; private set; }
    public ICommand RemoveImageFromProductCommand { get; private set; }
    #endregion Commands

    #region Methods
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
    private void NavigateToImageManagement() => MainFrame?.Navigate(new ImageManagementView() { DataContext = this });
    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame.NavigationService.GoBack();
    }
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
      SelectedUser = new UserModel();
      var editWindow = new EditUserView() { DataContext = this };
      editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
      editWindow.ShowDialog();
    }
    private void EditProduct(ProductModel? product)
    {
      if (product is not null)
      {
        IngredientList = IngredientDataProvider.LoadIngredients(product);
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
          //var addedProduct = ProductDataProvider.AddProduct(SelectedProduct); // Wenn nicht vorhanden -> Erstellen
          //if (addedProduct is not null)
          //  ProductList.Add(addedProduct);
          //else
          //  return;
        }
      }
      SelectedProduct = null;
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
      if (image is not null)
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

    private void CloseCurrentWindow() => Application.Current.Windows.OfType<Window>().SingleOrDefault(w => w.IsActive)?.Close();
    #endregion Methods
  }
}
