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
    #endregion Properties
  }
}
