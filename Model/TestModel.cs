using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class TestModel : NotifyObject
  {
    public int TestInt
    {
      get => Get<int>();
      set => Set(value);
    }

    public string TestString
    {
      get => Get<string>();
      set => Set(value);
    }
  }
}
