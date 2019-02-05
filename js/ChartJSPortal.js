window.onload = function () {
    var ctx = $("#myChart");
    if(Chart_datasets){
        var datasets = Chart_datasets;
    }else{
        var datasets = {};
    }
    if(Chart_titleText){
        var titleText = Chart_titleText;
    }else{
        var titleText = {};
    }
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: datasets,
        options: {
            "hover": {
                "animationDuration": 0
            },
            "animation": {
                //"duration": 1,
                "onComplete": function () {
                    var chartInstance = this.chart,
                        ctx = chartInstance.ctx;
                    ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
                    ctx.textAlign = 'center';
                    ctx.fillStyle = "#666666";
                    ctx.strokeStyle= "rgb(0, 0, 0)";
                    ctx.textBaseline = 'bottom';
                    this.data.datasets.forEach(function (dataset, i) {
                        if(dataset._meta[0].hidden != true) {
                            var meta = chartInstance.controller.getDatasetMeta(i);
                            meta.data.forEach(function (bar, index) {
                                var data = dataset.data[index];
                                if (data.y > 0)
                                    ctx.fillText(data.y, bar._model.x, bar._model.y - 5);
                            });
                        }
                    });
                }
            },
            maintainAspectRatio: false,
            responsive: true,
            legend: {
                "display": true
            },
            title: {
                display: true,
                text: titleText
            },
            tooltips: {
                enabled: false,
                mode: 'index',
                intersect: true,
                custom: function(tooltipModel) {
                    // Tooltip Element
                    var tooltipEl = document.getElementById('chartjs-tooltip');
                    // Create element on first render
                    if (!tooltipEl) {
                        tooltipEl = document.createElement('div');
                        tooltipEl.id = 'chartjs-tooltip';
                        tooltipEl.innerHTML = "<table></table>";
                        document.body.appendChild(tooltipEl);
                    }
                    // Hide if no tooltip
                    if (tooltipModel.opacity === 0) {
                        tooltipEl.style.opacity = 0;
                        return;
                    }
                    // Set caret Position
                    tooltipEl.classList.remove('above', 'below', 'no-transform');
                    if (tooltipModel.yAlign) {
                        tooltipEl.classList.add(tooltipModel.yAlign);
                    } else {
                        tooltipEl.classList.add('no-transform');
                    }
                    function getBody(bodyItem) {
                        return bodyItem.lines;
                    }
                    // Set Text
                    if (tooltipModel.body) {
                        var titleLines = tooltipModel.title || [];
                        var bodyLines = tooltipModel.body.map(getBody);
                        var innerHtml = '<thead>';
                        titleLines.forEach(function(title) {
                            innerHtml += '<tr><th>' + title + '</th></tr>';
                        });
                        innerHtml += '</thead><tbody>';
                        bodyLines.forEach(function(body, i) {
                            var colors = tooltipModel.labelColors[i];
                            var style = 'background:' + colors.backgroundColor;
                            style += '; border-color:' + colors.borderColor;
                            style += '; position: relative';
                            style += '; display: inline-block';
                            style += '; margin-right: 10px';
                            style += '; border-width: 2px';
                            style += '; width: 10px';
                            style += '; height: 10px';

                            var span = '<span style="' + style + '"></span>';
                            innerHtml += '<tr><td>' + span + body + '</td></tr>';
                        });
                        innerHtml += '</tbody>';

                        var tableRoot = tooltipEl.querySelector('table');
                        tableRoot.innerHTML = innerHtml;
                    }
                    // `this` will be the overall tooltip
                    var position = this._chart.canvas.getBoundingClientRect();
                    // Display, position, and set styles for font
                    tooltipEl.style.opacity = 1;
                    tooltipEl.style.background = "rgba(0,0,0,0.8)";
                    tooltipEl.style.borderRadius = "2px";
                    tooltipEl.style.overflow = "hidden";
                    tooltipEl.style.position = 'absolute';
                    tooltipEl.style.left = position.left + window.pageXOffset + tooltipModel.caretX + 'px';
                    tooltipEl.style.top = position.top + window.pageYOffset + tooltipModel.caretY + 'px';
                    tooltipEl.style.fontFamily = tooltipModel._bodyFontFamily;
                    tooltipEl.style.fontSize = tooltipModel.bodyFontSize + 'px';
                    tooltipEl.style.fontStyle = tooltipModel._bodyFontStyle;
                    tooltipEl.style.color = "#ffffff";
                    console.log(tooltipEl.style);
                    tooltipEl.style.padding = tooltipModel.yPadding + 'px ' + tooltipModel.xPadding + 'px';
                    tooltipEl.style.pointerEvents = 'none';
                }
            },
            scales: {
                yAxes: [{
                    display: false,
                    gridLines: {
                        display : false
                    },
                    ticks: {
                        //max: Math.max(...data.datasets[0].data) + 10,
                        display: false,
                        beginAtZero:true
                    }
                }],
                xAxes: [{
                    gridLines: {
                        display : false
                    },
                    ticks: {
                        autoSkip: false,
                        beginAtZero:true
                    }
                }]
            }
        }
    });
}
window.getColorRand = function(num=0){
    var back = [
        '#f67019',
        '#acc236',
        '#00a950',
        '#8549ba'];
    return back[num-1];
}