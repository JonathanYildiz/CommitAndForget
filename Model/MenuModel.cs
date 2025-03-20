using System.Collections.ObjectModel;
using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class MenuModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public string Name
    {
      get => Get<string>();
      set => Set(value);
    }

    public double Price
    {
      get => Get<double>();
      set => Set(value);
    }

    public double TotalPrice => Math.Round(Price * Quantity, 2);

    public ImageModel Image
    {
      get => Get<ImageModel>();
      set => Set(value);
    }

    public int Quantity
    {
      get => Get<int>();
      set => Set(value);

    }
    public int OrderCount
    {
      get => Get<int>();
      set => Set(value);
    }
    public ObservableCollection<ProductModel> ProductList
    {
      get => Get<ObservableCollection<ProductModel>>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public MenuModel()
    {
      Quantity = 1;
      ProductList = new ObservableCollection<ProductModel>();
      Image = new ImageModel();
    }

    public MenuModel(MenuModel menu)
    {
      Key = menu.Key;
      Name = menu.Name;
      Price = menu.Price;
      Image = new ImageModel(menu.Image);
      Quantity = menu.Quantity;
      ProductList = new ObservableCollection<ProductModel>(menu.ProductList);
    }
    #endregion Constructor

    #region Methods
    public void RollbackChanges(MenuModel backupMenu)
    {
      Key = backupMenu.Key;
      Name = backupMenu.Name;
      Price = backupMenu.Price;
      Image = new ImageModel(backupMenu.Image);
      Quantity = backupMenu.Quantity;
      ProductList = new ObservableCollection<ProductModel>(backupMenu.ProductList);
    }
    #endregion Methods
  }
}
