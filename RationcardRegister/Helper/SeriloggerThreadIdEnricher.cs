﻿using Serilog.Core;
using Serilog.Events;
using System.Threading;

namespace Helper
{
    public class SeriloggerThreadIdEnricher : ILogEventEnricher
    {
        public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
        {
            logEvent.AddPropertyIfAbsent(propertyFactory.CreateProperty(
                    "ThreadId", Thread.CurrentThread.ManagedThreadId));
        }
    }
}