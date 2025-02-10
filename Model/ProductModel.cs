using System.Collections.ObjectModel;
using CommitAndForget.Essentials;

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
    }
    #endregion Constructor
  }
}
