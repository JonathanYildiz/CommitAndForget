﻿using System.Collections.ObjectModel;
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
    }
    #endregion Constructor
  }
}
