using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using System.Windows.Navigation;
using System.Windows.Threading;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services;
using CommitAndForget.Services.DataProvider;
using CommitAndForget.View.UserViews;
using CommunityToolkit.Mvvm.Input;

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
    public ObservableCollection<IngredientModel> IngredientList
    {
      get => Get<ObservableCollection<IngredientModel>>();
      set => Set(value);
    }
    public ObservableCollection<ProductModel> ShoppingCart
    {
      get => Get<ObservableCollection<ProductModel>>();
      set => Set(value);
    }
    public IngredientModel SelectedIngredient
    {
      get => Get<IngredientModel>();
      set
      {
        Set(value);
        FilteredProductList.Refresh();
      }
    }
    public int ShoppingCartQuantity => ShoppingCart.Sum(item => item.Quantity);
    public bool ShowShoppingCart
    {
      get => Get<bool>();
      set => Set(value);
    }
    
    public Frame MainFrame
    {
      get => Get<Frame>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public UserViewModel(UserModel user)
    {
      CurrentUser = user;
      ProductList = new ObservableCollection<ProductModel>();
      ShoppingCart = new ObservableCollection<ProductModel>();      
      CreateCommands();
    }
    #endregion Constructor

    #region Commands
    private void CreateCommands()
    {
      NavigateToUserSelectionCommand = new RelayCommand(NavigateToUserSelection);
      NavigateToUserOrderCommand = new RelayCommand(NavigateToUserOrder);
      NavigateBackCommand = new RelayCommand(NavigateBack);
      NavigateToMenuCommand = new RelayCommand(NavigateToMenu);
      NavigateToProductCommand = new RelayCommand(NavigateToProduct);
      ToggleShowShoppingCartCommand = new RelayCommand(ToggleShowShoppingCart);
      AddToShoppingCartCommand = new RelayCommand<ProductModel>(AddToShoppingCart);
      ShowProductInfoCommand = new RelayCommand<ProductModel>(ShowProductInfo);
      RemoveFromShoppingCartCommand = new RelayCommand<ProductModel>(RemoveFromShoppingCart);
    }
    public ICommand NavigateToUserSelectionCommand { get; private set; }
    public ICommand NavigateToUserOrderCommand { get; private set; }
    public ICommand NavigateBackCommand { get; private set; }
    public ICommand NavigateToMenuCommand { get; private set; }
    public ICommand NavigateToProductCommand { get; private set; }
    public ICommand ToggleShowShoppingCartCommand { get; private set; }
    public ICommand AddToShoppingCartCommand { get; private set; }
    public ICommand ShowProductInfoCommand { get; private set; }
    public ICommand RemoveFromShoppingCartCommand { get; private set; }
    #endregion Commands

    #region Methods
    #region Navigation
    // Methoden zur Navigation (DataContext ist das zentrale UserViewModel)
    private void NavigateToUserSelection() => MainFrame?.Navigate(new UserSelectionView());
    private void NavigateToUserOrder() => MainFrame?.Navigate(new UserOrderView() { DataContext = this });
    private void NavigateToMenu()
    {
      MenuList = MenuDataProvider.LoadMenus();
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
        foreach(var ingredient in product.Ingredients)
        {
          if(!IngredientList.Contains(ingredient))
            IngredientList.Add(ingredient);
        }
      }

      FilteredProductList = CollectionViewSource.GetDefaultView(ProductList);
      FilteredProductList.Filter = FilterProducts;
      MainFrame?.Navigate(new ProductView() { DataContext = this });
    }

    private void ToggleShowShoppingCart() => ShowShoppingCart = !ShowShoppingCart;

    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame.NavigationService.GoBack();
    }
    #endregion Navigation

    private bool FilterProducts(object obj)
    {
      if(obj is ProductModel product)
      {
        if (SelectedIngredient is null)
          return true;
        else
          return product.Ingredients.FirstOrDefault(x => x.Key == SelectedIngredient.Key) != null;
      }
      
      return false;
    }

    private void AddToShoppingCart(ProductModel? product)
    {
      if(product is not null)
      {
        // Wenn Produkt bereits in Warenkorb => Menge erhöhen
        var productInList = ShoppingCart.FirstOrDefault(p => p.Key == product.Key);
        if (productInList is null)
          ShoppingCart.Add(product);
        else
          productInList.Quantity++;

        OnPropertyChanged(nameof(ShoppingCartQuantity));
      }
    }

    private void ShowProductInfo(ProductModel? product)
    {
      if (product is not null)
      {
        string ingredients = "";
        foreach (var ingredient in product.Ingredients)
          ingredients += ingredient.Name + "\n";

        MessageBoxService.DisplayMessage($"Produkt: {product.Name}\n\nZutaten:\n{ingredients}", MessageBoxImage.Information);
      }
    }

    private void RemoveFromShoppingCart(ProductModel? product)
    {
      if (product is not null)
      {
        ShoppingCart?.Remove(product);
        OnPropertyChanged(nameof(ShoppingCartQuantity));
      }
    }
    #endregion Methods
  }
}
