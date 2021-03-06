﻿using Microsoft.Phone.Controls;
using PGHTechFest.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PGHTechFest.Pages
{
    public class BasePage : PhoneApplicationPage
    {
        /// <summary>
        /// Identifies the <see cref="DefaultViewModel"/> dependency property.
        /// </summary>
        public static readonly DependencyProperty DefaultViewModelProperty =
            DependencyProperty.Register("DefaultViewModel", typeof(MainViewModel),
            typeof(BasePage), null);


        /// <summary>
        /// An implementation of <see cref="IObservableMap&lt;String, Object&gt;"/> designed to be
        /// used as a trivial view model.
        /// </summary>
        protected MainViewModel DefaultViewModel
        {
            get { return this.GetValue(DefaultViewModelProperty) as MainViewModel; }
            set { this.SetValue(DefaultViewModelProperty, value); }
        }

        public BasePage()
        {
            // Create an empty default view model
            this.DefaultViewModel = Application.Current.Resources["DataSource"] as MainViewModel;
        }

        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
 	         base.OnNavigatedTo(e);

             if (!DefaultViewModel.IsInitialized)
                 DefaultViewModel.Initialize();

            this.DefaultViewModel.InitializationError += DefaultViewModel_InitializationError;
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
 	         base.OnNavigatedFrom(e);

            this.DefaultViewModel.InitializationError -= DefaultViewModel_InitializationError;
        }

        private void DefaultViewModel_InitializationError(object sender, EventArgs e)
        {
            MessageBox.Show("There was a problem getting the conference data.", "Whoops", MessageBoxButton.OK);
        }

        public void Sessions_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/Pages/Sessions.xaml", UriKind.Relative));
        }

        public void Speakers_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/Pages/Speakers.xaml", UriKind.Relative));
        }

        public void Schedule_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/Pages/Schedule.xaml", UriKind.Relative));
        }
    }
}
