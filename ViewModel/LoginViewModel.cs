using System.Collections.ObjectModel;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services.DataProvider;

namespace CommitAndForget.ViewModel
{
  public class LoginViewModel : NotifyObject
  {
    ObservableCollection<TestModel> TestList
    {
      get => Get<ObservableCollection<TestModel>>();
      set => Set(value);
    }
    
    public LoginViewModel()
    {
      TestList = TestDataProvider.LoadTestData();
    }

  }
}
