###
# Copyright (C) 2014-2018 Taiga Agile LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: modules/user-settings/3bot-login.coffee
###

taiga = @.taiga

mixOf = @.taiga.mixOf
debounce = @.taiga.debounce

module = angular.module("taigaUserSettings")


#############################################################################
## User 3BotLogin Controller
#############################################################################

class User3botLoginController extends mixOf(taiga.Controller, taiga.PageMixin)
    @.$inject = [
        "$scope",
        "$tgAuth",
        "$translate"
    ]

    constructor: (@scope, @auth, @translate) ->
        @scope.sectionName = @translate.instant("USER_SETTINGS.THREEBOT_SETTINGS.SECTION_NAME")
        @scope.user = @auth.getUser()
module.controller("User3botLoginController", User3botLoginController)


#############################################################################
## User 3BotLogin Directive
#############################################################################

UserThreebotLoginDirective = ($auth, $location, $navUrls, config) ->
    link = ($scope, locationService) ->
        $scope.threeBotLogin = false
        $scope.username = $scope.user.username
        $scope.email = $scope.user.email
        $scope.pubKey = $scope.user.public_key
        if $scope.user.public_key == ''
            $scope.threeBotLogin = false
        else
            $scope.threeBotLogin = true

        $scope.linkAccount = () ->
            url = config.get('api') + "threebot/login"
            $.ajax url,
            type: 'GET'

            error: (jqXHR, textStatus, errorThrown) ->
                console.log('Error', textStatus)
            success: (data, textStatus, jqXHR) ->
                locationService.url = data.url
                window.location.href = locationService.url;

    return {
        link:link
    }

module.directive("tgThreebotSettings", ["$tgAuth","$tgLocation", "$tgNavUrls", "$tgConfig", "$tgLocation", UserThreebotLoginDirective])
