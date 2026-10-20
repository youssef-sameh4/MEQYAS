using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyAlerts.Queries.DTOS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Queries.Models
{
    public class GetAllEnergyAlertsQuery : IRequest<Response<List<EnergyAlertDto>>>
    {
    }
}
