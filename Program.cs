using System;
using System.Collections;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace libfaketime
{
    class Program
    {
        const int DATE_CHANGE_INTERVAL = 5000;
        const int SLEEP_INTERVAL = 1000;
        static void Main(string[] args)
        {
            System.Timers.Timer tmr = new System.Timers.Timer(DATE_CHANGE_INTERVAL);
            tmr.Elapsed += TimerElapsed;
            tmr.Enabled = true;
            while (true)
            {
                Console.WriteLine(DateTime.Now);
                Thread.Sleep(SLEEP_INTERVAL);
            }
        }

        static async void TimerElapsed(object sender, EventArgs e)
        {
            var maxDaysOffset = 999;
            int randomOffset = new Random().Next(maxDaysOffset);
            await SetSystemOffsetAsync("+" + randomOffset + "d");
        }

        static async Task SetSystemDateAsync(DateTime systemDate) => await File.WriteAllTextAsync("/etc/faketimerc", systemDate.ToString());
        static async Task SetSystemOffsetAsync(string offset)
        {
            System.Console.WriteLine("Setting days offset " + offset);
            await File.WriteAllTextAsync("/etc/faketimerc", offset);
        }
    }
}
