using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class MenuDataProvider
  {
    public static ObservableCollection<MenuModel> LoadMenus()
    {
      // Load menu from database
      return [];
    }
  }
}
