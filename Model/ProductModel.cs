using CommitAndForget.Essentials;
using System.Collections.ObjectModel;

namespace CommitAndForget.Model
{
  public class ProductModel : NotifyObject
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

    public int Energy
    {
      get => Get<int>();
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
      set
      {
        Set(value);
        OnPropertyChanged(nameof(TotalPrice));
      }
    }

    public bool IsChecked
    {
      get => Get<bool>();
      set => Set(value);
    }

    public int OrderCount
    {
      get => Get<int>();
      set => Set(value);
    }

    public ObservableCollection<IngredientModel> Ingredients
    {
      get => Get<ObservableCollection<IngredientModel>>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public ProductModel()
    {
      Quantity = 1;
      Ingredients = new ObservableCollection<IngredientModel>();
      Image = new ImageModel();
    }
    public ProductModel(ProductModel product)
    {
      Key = product.Key;
      Name = product.Name;
      Energy = product.Energy;
      Price = product.Price;
      Image = new ImageModel(product.Image);
      Quantity = product.Quantity;
      Ingredients = new ObservableCollection<IngredientModel>(product.Ingredients);
    }
    #endregion Constructor

    #region Methods
    public void RollbackChanges(ProductModel backupProduct)
    {
      Key = backupProduct.Key;
      Name = backupProduct.Name;
      Energy = backupProduct.Energy;
      Price = backupProduct.Price;
      Image = new ImageModel(backupProduct.Image);
      Quantity = backupProduct.Quantity;
      Ingredients = new ObservableCollection<IngredientModel>(backupProduct.Ingredients);
    }
    #endregion Methods
  }
}
