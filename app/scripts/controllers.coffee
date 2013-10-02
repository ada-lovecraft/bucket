'use strict'

### Controllers ###

app = angular.module('app')

app.controller 'AppController', ($scope) ->
  $scope.app =
    title: "Brunch with Edge Benedict"
  console.log 'app controller'



app.controller 'MainController', ($scope, $filter, TableService, $http) ->
  console.log 'maincontroller'

  $scope.main = 
    data: null
    tableConfig:
      display:
        fileName: 
          label: 'File Name'
          className: 'col-md-2'
          format: (value, row) ->
            console.log 'file', row.file
            return '<a href="' + row.file + '">' + value + '</a>'
        file:
          label: 'Actions'
          format: (value) ->
            return '<a href="' + value+'">Download</a>'
          className: 'col-md-2'
        dateUploaded: 
          label: 'Date Uploaded'
          className: 'col-md-2'
          format: (value) ->
            date = new Date(value)
            return $filter('date')(date,'shortDate')

      order: ['fileName','dateUploaded']
    getData: ->
      $http.get('/files').then (response) ->
        $scope.main.data = response.data

  $scope.main.getData()

