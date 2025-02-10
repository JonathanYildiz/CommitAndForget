using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class IngredientModel : NotifyObject
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
    public double Quantity
    {
      get => Get<double>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public IngredientModel()
    {
      Quantity = 1;
    }
    #endregion Constructor
  }
}
