#include <napi.h>

#import <LocalAuthentication/LocalAuthentication.h>

// No-op value to pass into function parameter for ThreadSafeFunction
Napi::Value NoOp(const Napi::CallbackInfo &info) {
  return info.Env().Undefined();
}

Napi::Value CheckBiometricAuthChanged(const Napi::CallbackInfo &info) {
  Napi::Env env = info.Env();

  LAContext *context = [[LAContext alloc] init];
  NSError *error = nil;
  bool changed = NO;

  // Check if device supports biometric authentication
  if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                           error:&error]) {
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil];
    NSData *domainState = [context evaluatedPolicyDomainState];

    // load the last domain state from touch id
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *oldDomainState = [defaults objectForKey:@"macBiometricAuthState"];

    if (oldDomainState) {
      // check for domain state changes
      if ([oldDomainState isEqual:domainState]) {
        NSLog(@"nothing changed.");
      } else {
        changed = YES;
        NSLog(@"domain state was changed!");
      }
    }

    // save the domain state that will be loaded next time
    [defaults setObject:domainState forKey:@"macBiometricAuthState"];
    [defaults synchronize];
  }

  return Napi::Boolean::New(env, changed);
}

// Initializes all functions exposed to JS
Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "checkBiometricAuthChanged"),
              Napi::Function::New(env, CheckBiometricAuthChanged));

  return exports;
}

NODE_API_MODULE(permissions, Init)